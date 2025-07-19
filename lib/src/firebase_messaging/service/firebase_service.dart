import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer';
import '../constants.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class FirebaseService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Singleton pattern
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Last received message
  RemoteMessage? _lastMessage;
  RemoteMessage? get lastMessage => _lastMessage;

  // FCM Token
  String? _token;
  String? get token => _token;

  // Permission status
  NotificationSettings? _settings;
  NotificationSettings? get settings => _settings;

  void Function()? onMessageReceived;

  // Initialize FCM and set up handlers
  Future<void> init() async {
    try {
      log(FirebaseMessagingConstants.requestingPermission);
      _settings = await _messaging.requestPermission();
      log(
        '${FirebaseMessagingConstants.permissionStatus}: ${_settings?.authorizationStatus}',
      );
      print(
        '${FirebaseMessagingConstants.permissionStatus}: ${_settings?.authorizationStatus}',
      );

      if (_settings?.authorizationStatus != AuthorizationStatus.authorized) {
        throw Exception(FirebaseMessagingConstants.permissionDenied);
      }

      log(FirebaseMessagingConstants.gettingToken);
      _token = await _messaging.getToken();
      log('${FirebaseMessagingConstants.token}: $_token');
      print('${FirebaseMessagingConstants.token}: $_token');

      if (_token == null) {
        throw Exception(FirebaseMessagingConstants.noToken);
      }

      // Listen for token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        _token = newToken;
        log('${FirebaseMessagingConstants.tokenRefreshed}: $_token');
        print('${FirebaseMessagingConstants.tokenRefreshed}: $_token');
      });

      // Foreground message handler
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log(
          '${FirebaseMessagingConstants.foregroundMessage}: ${message.messageId}',
        );
        _lastMessage = message;
        if (onMessageReceived != null) onMessageReceived!();
        // Show a local notification in foreground
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
            channelKey: 'basic_channel',
            title: message.notification?.title ?? 'Push Notification',
            body: message.notification?.body ?? 'You have a new message.',
          ),
        );
      });

      // Background/terminated message handler
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        log(
          '${FirebaseMessagingConstants.openedFromBackground}: ${message.messageId}',
        );
        _lastMessage = message;
      });

      // Optionally subscribe to a default topic
      await subscribeToTopic(FirebaseMessagingConstants.defaultTopic);
    } catch (e, stack) {
      log(
        '${FirebaseMessagingConstants.errorInitializing}: ${e.toString()}',
        stackTrace: stack,
      );
      print('${FirebaseMessagingConstants.errorInitializing}: ${e.toString()}');
      rethrow;
    }
  }

  // Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      log(FirebaseMessagingConstants.subscribedToTopic);
      print('${FirebaseMessagingConstants.subscribedToTopic}: $topic');
    } catch (e) {
      log('${FirebaseMessagingConstants.errorSubscribing}: ${e.toString()}');
      print('${FirebaseMessagingConstants.errorSubscribing}: ${e.toString()}');
    }
  }

  // Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      log(FirebaseMessagingConstants.unsubscribedFromTopic);
      print('${FirebaseMessagingConstants.unsubscribedFromTopic}: $topic');
    } catch (e) {
      log('${FirebaseMessagingConstants.errorUnsubscribing}: ${e.toString()}');
      print(
        '${FirebaseMessagingConstants.errorUnsubscribing}: ${e.toString()}',
      );
    }
  }

  // Expose permission request
  Future<NotificationSettings> requestPermission() async {
    _settings = await _messaging.requestPermission();
    log(
      '${FirebaseMessagingConstants.permissionRequested}: ${_settings?.authorizationStatus}',
    );
    print(
      '${FirebaseMessagingConstants.permissionRequested}: ${_settings?.authorizationStatus}',
    );
    if (_settings?.authorizationStatus != AuthorizationStatus.authorized) {
      throw Exception(FirebaseMessagingConstants.permissionDenied);
    }
    return _settings!;
  }

  void clearLastMessage() {
    _lastMessage = null;
  }
}
