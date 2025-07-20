class FirebaseMessagingConstants {
  static const String defaultTopic = 'general';
  static const String requestingPermission = '[FCM] Requesting notification permissions...';
  static const String permissionStatus = '[FCM] Permission status';
  static const String permissionDenied = 'Push notification permission denied or not determined. Please enable notifications in system settings.';
  static const String gettingToken = '[FCM] Getting FCM token...';
  static const String token = '[FCM] FCM Token';
  static const String noToken = 'No FCM token generated. Check permission and network connectivity.';
  static const String tokenRefreshed = '[FCM] Token refreshed';
  static const String foregroundMessage = '[FCM] Foreground message';
  static const String openedFromBackground = '[FCM] Message opened from terminated/background';
  static const String errorInitializing = '[FCM] Error initializing FCM';
  static const String subscribedToTopic = '[FCM] Subscribed to topic';
  static const String errorSubscribing = '[FCM] Error subscribing to topic';
  static const String unsubscribedFromTopic = '[FCM] Unsubscribed from topic';
  static const String errorUnsubscribing = '[FCM] Error unsubscribing from topic';
  static const String permissionRequested = '[FCM] Permission requested';
}
