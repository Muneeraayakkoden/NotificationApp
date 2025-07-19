import 'package:flutter/material.dart';
import '../service/firebase_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';

class FirebaseProvider extends ChangeNotifier {
  final FirebaseService _service = FirebaseService();

  RemoteMessage? get lastMessage => _service.lastMessage;
  String? get token => _service.token;
  NotificationSettings? get settings => _service.settings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  String? _error;
  String? get error => _error;

  FirebaseProvider();

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    try {
      _service.onMessageReceived = () => notifyListeners();
      await _service.init();
      _error = null;
      _isInitialized = true;
    } catch (e, stack) {
      _error = e.toString();
      log('[Provider] Error initializing: $_error', stackTrace: stack);
      _isInitialized = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
    clearLastMessage();
  }

  void clearLastMessage() {
    _service.clearLastMessage();
    notifyListeners();
  }

  Future<void> requestPermission() async {
    try {
      await _service.requestPermission();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _service.subscribeToTopic(topic);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _service.unsubscribeFromTopic(topic);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
