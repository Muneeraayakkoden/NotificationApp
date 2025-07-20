import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class AwesomeService {
  static final AwesomeService _instance = AwesomeService._internal();
  factory AwesomeService() => _instance;
  AwesomeService._internal();

  /// Initialize Awesome Notifications 
  Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null, // Use default app icon
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic group',
        ),
      ],
      debug: true,
    );
    // Request permission for notifications
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  // Basic Notification
  Future<void> showBasicNotification({
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        channelKey: 'basic_channel',
        title: title,
        body: body,
      ),
    );
  }

  // Big Picture Notification
  Future<void> showBigPictureNotification({
    required String title,
    required String body,
    required String bigPicture,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        channelKey: 'basic_channel',
        notificationLayout: NotificationLayout.BigPicture,
        title: title,
        body: body,
        bigPicture: bigPicture,
      ),
    );
  }

  // Media Notification
  Future<void> showMediaNotification({
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        channelKey: 'media_channel',
        notificationLayout: NotificationLayout.MediaPlayer,
        title: title,
        body: body,
      ),
    );
  }

  // Big Text Notification
  Future<void> showBigTextNotification({
    required String title,
    required String bigText,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        channelKey: 'big_text_channel',
        notificationLayout: NotificationLayout.BigText,
        title: title,
        body: bigText,
      ),
    );
  }

  // Inbox Notification
  Future<void> showInboxNotification({
    required String title,
    required String body,
    required List<String> lines,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        channelKey: 'inbox_channel',
        notificationLayout: NotificationLayout.Inbox,
        title: title,
        body: body,
        summary: 'Summary',
      ),
      actionButtons: [
        NotificationActionButton(key: 'VIEW', label: 'View'),
        NotificationActionButton(key: 'DISMISS', label: 'Dismiss'),
      ],
    );
  }

  // Messaging Notification
  Future<void> showMessagingNotification({
    required String title,
    required String body,
    required List<Map<String, dynamic>> messages,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        channelKey: 'messaging_channel',
        notificationLayout: NotificationLayout.Messaging,
        title: title,
        body: body,
        summary: 'New messages',
      ),
      actionButtons: [
        NotificationActionButton(key: 'REPLY', label: 'Reply'),
        NotificationActionButton(key: 'READ', label: 'Mark as read'),
      ],
    );
  }

  // Messaging Group Notification
  Future<void> showMessagingGroupNotification({
    required String title,
    required String body,
    required List<Map<String, dynamic>> messages,
    required String groupKey,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        channelKey: 'messaging_channel',
        notificationLayout: NotificationLayout.MessagingGroup,
        title: title,
        body: body,
        groupKey: groupKey,
        summary: 'New messages',
      ),
      actionButtons: [
        NotificationActionButton(key: 'REPLY', label: 'Reply'),
        NotificationActionButton(key: 'READ', label: 'Mark as read'),
      ],
    );
  }

  // Notification with Action Buttons
  Future<void> showNotificationWithActions({
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        channelKey: 'basic_channel',
        title: title,
        body: body,
      ),
      actionButtons: [
        NotificationActionButton(key: 'ACCEPT', label: 'Accept'),
        NotificationActionButton(
          key: 'REJECT',
          label: 'Reject',
          isDangerousOption: true,
        ),
      ],
    );
  }

  // Grouped Notifications
  Future<void> showGroupedNotifications({
    required String title,
    required String body,
    required String groupKey,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        groupKey: groupKey,
      ),
    );
  }

  // Progress Bar Notification (Android only)
  Future<void> showProgressNotification({
    required String title,
    required String body,
    required int progress,
    required bool indeterminate,
    required int id,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id, // Use the same id for updates
        channelKey: 'progress_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.ProgressBar,
        progress: progress.toDouble(), // Convert to double
        locked: true,
        autoDismissible: progress >= 100,
      ),
    );
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}
