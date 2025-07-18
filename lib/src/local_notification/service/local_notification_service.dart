import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    try {
      debugPrint('🔄 Initializing notification service...');
      await requestPermissions();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            macOS: initializationSettingsDarwin,
          );
      final bool? initialized = await flutterLocalNotificationsPlugin
          .initialize(
            initializationSettings,
            onDidReceiveNotificationResponse: _onNotificationTapped,
          );

      if (initialized == true) {
        debugPrint('✅ Notification service initialized successfully');
      } else {
        debugPrint('❌ Failed to initialize notification service');
      }

      // Initialize timezone
      await _initializeTimezone();
    } catch (e) {
      debugPrint('❌ Error initializing notification service: $e');
      rethrow;
    }
  }

  Future<void> requestPermissions() async {
    try {
      debugPrint('🔄 Requesting notification permissions...');

      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      if (result == true) {
        debugPrint('✅ Notification permissions granted');
      } else {
        debugPrint('❌ Notification permissions denied');
      }

      // Request exact alarm permission for scheduled notifications
      final bool? exactAlarmResult = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestExactAlarmsPermission();

      if (exactAlarmResult == true) {
        debugPrint('✅ Exact alarm permissions granted');
      } else {
        debugPrint('❌ Exact alarm permissions denied');
      }
    } catch (e) {
      debugPrint('❌ Error requesting permissions: $e');
    }
  }

  Future<void> _initializeTimezone() async {
    try {
      debugPrint('🔄 Initializing timezone...');
      tz.initializeTimeZones();
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      debugPrint('✅ Timezone initialized: $timeZoneName');
    } catch (e) {
      debugPrint('❌ Error initializing timezone: $e');
    }
  }

  void _onNotificationTapped(NotificationResponse notificationResponse) {
    debugPrint('🔔 Notification tapped: ${notificationResponse.payload}');
    if (notificationResponse.actionId == 'stop_chronometer') {
      debugPrint(
        '🛑 Stop action received for chronometer. Cancelling notifications.',
      );
      flutterLocalNotificationsPlugin.cancelAll();
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
      debugPrint('✅ All notifications cancelled');
    } catch (e) {
      debugPrint('❌ Error cancelling notifications: $e');
    }
  }
}
