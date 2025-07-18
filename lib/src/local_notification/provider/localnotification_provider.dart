import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../service/local_notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _service;
  int notificationId = 0;

  NotificationProvider(this._service);

  Future<void> showBasicNotification() async {
    try {
      debugPrint('🔄 Attempting to show basic notification...');
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
            'test_channel_id',
            'Test Notifications',
            channelDescription: 'Test notification channel',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            showWhen: true,
            when: null,
            usesChronometer: false,
            channelShowBadge: true,
            onlyAlertOnce: false,
            ongoing: false,
            autoCancel: true,
            silent: false,
          );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );
      final int currentId = notificationId++;
      debugPrint('🔔 Showing notification with ID: $currentId');
      await _service.flutterLocalNotificationsPlugin.show(
        currentId,
        'Basic Notification',
        'Basic notification sent!',
        notificationDetails,
      );
      debugPrint('✅ Basic notification sent successfully with ID: $currentId');
    } catch (e) {
      debugPrint('❌ Error sending basic notification: $e');
      debugPrint('❌ Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> showScheduledNotification() async {
    try {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
            'scheduled_channel',
            'Scheduled Notifications',
            channelDescription: 'Channel for scheduled notifications',
            importance: Importance.max,
            priority: Priority.high,
            // icon: 'app_icon', // Removed to use default launcher icon
            ticker: 'Scheduled notification incoming...',
          );

      const DarwinNotificationDetails darwinNotificationDetails =
          DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
        macOS: darwinNotificationDetails,
      );

      final scheduledTime = tz.TZDateTime.now(
        tz.local,
      ).add(const Duration(seconds: 5));

      await _service.flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId++,
        '⏰ Scheduled Notification',
        'This notification was scheduled 5 seconds ago!',
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint(
        '✅ Scheduled notification set for: ${scheduledTime.toString()}',
      );
    } catch (e) {
      debugPrint('❌ Error scheduling notification: $e');
    }
  }

  Future<void> showProgressNotification() async {
    try {
      const int maxProgress = 100;
      const int progressId = 999; // Use fixed ID for progress updates
      // Show initial progress notification
      for (int progress = 0; progress <= maxProgress; progress += 20) {
        AndroidNotificationDetails androidNotificationDetails;
        if (progress < maxProgress) {
          androidNotificationDetails = AndroidNotificationDetails(
            'progress_channel',
            'Progress Notifications',
            channelDescription: 'Channel for progress notifications',
            importance: Importance.max,
            priority: Priority.high,
            showProgress: true,
            maxProgress: maxProgress,
            progress: progress,
            onlyAlertOnce: true,
            ongoing: true,
            autoCancel: false,
          );
        } else {
          androidNotificationDetails = AndroidNotificationDetails(
            'progress_channel',
            'Progress Notifications',
            channelDescription: 'Channel for progress notifications',
            importance: Importance.max,
            priority: Priority.high,
            showProgress: false,
            maxProgress: maxProgress,
            onlyAlertOnce: true,
            ongoing: false,
            autoCancel: false,
          );
        }
        final NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails,
        );
        await _service.flutterLocalNotificationsPlugin.show(
          progressId,
          '📊 Download Progress',
          progress < maxProgress
              ? 'Downloading... $progress% complete'
              : '✅ Download completed!',
          notificationDetails,
        );
        if (progress < maxProgress) {
          await Future.delayed(const Duration(milliseconds: 800));
        }
      }
      debugPrint('✅ Progress notification sequence completed');
    } catch (e) {
      debugPrint('❌ Error showing progress notification: $e');
    }
  }

  Future<void> showActionNotification() async {
    try {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
            'actions_channel',
            'Actions Notifications',
            channelDescription: 'Channel for notifications with actions',
            importance: Importance.max,
            priority: Priority.high,
            // icon: 'app_icon', // Removed to use default launcher icon
            actions: <AndroidNotificationAction>[
              AndroidNotificationAction(
                'reply',
                '💬 Reply',
                showsUserInterface: true,
                allowGeneratedReplies: true,
              ),
              AndroidNotificationAction(
                'like',
                '👍 Like',
                showsUserInterface: false,
              ),
              AndroidNotificationAction(
                'dismiss',
                '❌ Dismiss',
                cancelNotification: true,
              ),
            ],
          );

      const DarwinNotificationDetails darwinNotificationDetails =
          DarwinNotificationDetails(
            categoryIdentifier: 'actions',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
        macOS: darwinNotificationDetails,
      );

      await _service.flutterLocalNotificationsPlugin.show(
        notificationId++,
        '🎯 Interactive Notification',
        'Tap the action buttons below to interact with this notification!',
        notificationDetails,
        payload: 'action_notification',
      );

      debugPrint('✅ Action notification sent successfully');
    } catch (e) {
      debugPrint('❌ Error sending action notification: $e');
    }
  }

  Future<void> showGroupedNotifications() async {
    try {
      const String groupKey = 'com.example.group';
      const String groupChannelId = 'grouped_channel';
      const String groupChannelName = 'Grouped Notifications';

      // Create messaging style for grouped notifications
      final List<Message> messages = [
        Message('Hello! How are you?', DateTime.now(), Person(name: 'Alice')),
        Message(
          'Are we still meeting today?',
          DateTime.now(),
          Person(name: 'Bob'),
        ),
        Message(
          'Don\'t forget about the presentation!',
          DateTime.now(),
          Person(name: 'Charlie'),
        ),
      ];

      final MessagingStyleInformation messagingStyle =
          MessagingStyleInformation(
            const Person(name: 'You'),
            groupConversation: true,
            conversationTitle: 'Team Chat',
            htmlFormatContent: true,
            htmlFormatTitle: true,
            messages: messages,
          );

      // First notification
      const AndroidNotificationDetails firstNotificationAndroidDetails =
          AndroidNotificationDetails(
            groupChannelId,
            groupChannelName,
            channelDescription: 'Channel for grouped notifications',
            importance: Importance.max,
            priority: Priority.high,
            groupKey: groupKey,
            // icon: 'app_icon', // Removed to use default launcher icon
          );

      await _service.flutterLocalNotificationsPlugin.show(
        notificationId++,
        '💬 Alice',
        'Hello! How are you?',
        const NotificationDetails(android: firstNotificationAndroidDetails),
      );

      // Add delay to show stacking effect
      await Future.delayed(const Duration(milliseconds: 500));

      // Second notification
      await _service.flutterLocalNotificationsPlugin.show(
        notificationId++,
        '💬 Bob',
        'Are we still meeting today?',
        const NotificationDetails(android: firstNotificationAndroidDetails),
      );

      // Add delay to show stacking effect
      await Future.delayed(const Duration(milliseconds: 500));

      // Third notification
      await _service.flutterLocalNotificationsPlugin.show(
        notificationId++,
        '💬 Charlie',
        'Don\'t forget about the presentation!',
        const NotificationDetails(android: firstNotificationAndroidDetails),
      );

      // Summary notification with messaging style
      final AndroidNotificationDetails summaryNotificationDetails =
          AndroidNotificationDetails(
            groupChannelId,
            groupChannelName,
            channelDescription: 'Channel for grouped notifications',
            importance: Importance.max,
            priority: Priority.high,
            groupKey: groupKey,
            setAsGroupSummary: true,
            styleInformation: messagingStyle,
            // icon: 'app_icon', // Removed to use default launcher icon
          );

      await _service.flutterLocalNotificationsPlugin.show(
        notificationId++,
        '👥 Team Chat',
        '3 new messages',
        NotificationDetails(android: summaryNotificationDetails),
      );

      debugPrint('✅ Grouped notifications sent successfully');
    } catch (e) {
      debugPrint('❌ Error sending grouped notifications: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _service.cancelAllNotifications();
      notificationId = 0; // Reset the notification ID counter
      debugPrint('✅ All notifications cancelled successfully');
    } catch (e) {
      debugPrint('❌ Error cancelling notifications: $e');
    }
  }

  // Additional advanced notification features
  Future<void> showCustomSoundNotification() async {
    try {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
            'custom_sound_channel_v2',
            'Custom Sound Notifications',
            channelDescription: 'Channel for notifications with custom sounds',
            importance: Importance.max,
            priority: Priority.high,
            // icon: 'app_icon', // Removed to use default launcher icon
            sound: RawResourceAndroidNotificationSound('slow_spring_board'),
            playSound: true,
          );

      const DarwinNotificationDetails darwinNotificationDetails =
          DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            sound: 'notification_sound.aiff',
          );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
        macOS: darwinNotificationDetails,
      );

      await _service.flutterLocalNotificationsPlugin.show(
        notificationId++,
        '🔊 Custom Sound Notification',
        'This notification has a custom sound (if available)',
        notificationDetails,
        payload: 'custom_sound_notification',
      );

      debugPrint('✅ Custom sound notification sent successfully');
    } catch (e) {
      debugPrint('❌ Error sending custom sound notification: $e');
    }
  }

  Future<void> showSilentNotification() async {
    try {
      debugPrint('🔄 Attempting to show silent notification...');
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
            'silent_channel',
            'Silent Notifications',
            channelDescription: 'Channel for silent notifications',
            importance: Importance.low,
            priority: Priority.low,
            silent: true,
            playSound: false,
            autoCancel: true,
          );
      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );
      await _service.flutterLocalNotificationsPlugin.show(
        notificationId++,
        '🔕 Silent Notification',
        'This notification makes no sound or vibration.',
        notificationDetails,
      );
      debugPrint('✅ Silent notification sent successfully');
    } catch (e) {
      debugPrint('❌ Error sending silent notification: $e');
    }
  }

  Future<void> showChronometerNotification() async {
    try {
      debugPrint('🔄 Attempting to show chronometer notification...');
      final now = DateTime.now().millisecondsSinceEpoch;
      final AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
            'chronometer_channel',
            'Chronometer Notifications',
            channelDescription: 'Channel for chronometer notifications',
            importance: Importance.max,
            priority: Priority.high,
            usesChronometer: true,
            showWhen: true,
            when: now,
            autoCancel: false,
            actions: <AndroidNotificationAction>[
              AndroidNotificationAction(
                'stop_chronometer',
                '🛑 Stop',
                cancelNotification: true,
              ),
            ],
          );
      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );
      await _service.flutterLocalNotificationsPlugin.show(
        notificationId++,
        '⏱️ Chronometer Notification',
        'This notification shows a running timer. Tap Stop to end.',
        notificationDetails,
        payload: 'chronometer',
      );
      debugPrint('✅ Chronometer notification sent successfully');
    } catch (e) {
      debugPrint('❌ Error sending chronometer notification: $e');
    }
  }
}
