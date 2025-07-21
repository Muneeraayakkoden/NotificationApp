import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/onesignal_provider.dart';
import '../view/onesignal_view.dart';

class OneSignalService {
  static const String _appId = '4c492a9d-2092-43e3-a1f4-ed734aa08329';

  static Future<void> initializeOneSignal() async {
    try {
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      OneSignal.initialize(_appId);
      debugPrint('[OneSignalService] OneSignal initialized');

      // Prompt for push notification permission
      await OneSignal.Notifications.requestPermission(true);

      // Listen for push notifications (foreground)
      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        debugPrint(
          'Foreground notification event: ${event.notification.jsonRepresentation()}',
        );
        final message = event.notification.body ?? 'No message';
        debugPrint('[OneSignalService] Push notification received: $message');
        Provider.of<OnesignalProvider>(
          navigatorKey.currentContext!,
          listen: false,
        );
        event.notification.display(); // This should show the notification
      });

      // Listen for in-app message clicks
      OneSignal.InAppMessages.addClickListener((event) {
        final message = event.jsonRepresentation();
        debugPrint('[OneSignalService] In-app message received: $message');
        Provider.of<OnesignalProvider>(
          navigatorKey.currentContext!,
          listen: false,
        );
        navigatorKey.currentState?.pushNamed('/onesignal');
      });

      // Listen for notification opens (background/terminated)
      OneSignal.Notifications.addClickListener((event) {
        final message = event.notification.body ?? 'No message (opened)';
        debugPrint('[OneSignalService] Push notification opened: $message');
        Provider.of<OnesignalProvider>(
          navigatorKey.currentContext!,
          listen: false,
        );

        // Navigate to /onesignal
        navigatorKey.currentState?.pushNamed('/onesignal');
      });
    } catch (e, stack) {
      debugPrint('[OneSignalService] Error initializing OneSignal: $e\n$stack');
    }
  }
}
