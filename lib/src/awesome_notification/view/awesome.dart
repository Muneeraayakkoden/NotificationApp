import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/awesome_provider.dart';
import '../../widget/notification_button.dart';

class Awesome extends StatelessWidget {
  const Awesome({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AwesomeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Awesome Notification',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple.shade700,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey.shade50, Colors.grey.shade100],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              NotificationButtons(
                configs: getNotificationButtonConfigs(provider),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<NotificationButtonConfig> getNotificationButtonConfigs(
  AwesomeProvider provider,
) => [
  NotificationButtonConfig(
    label: _NotificationButtonLabels.basic,
    onPressed: provider.showBasicNotification,
  ),
  NotificationButtonConfig(
    label: _NotificationButtonLabels.bigPicture,
    onPressed: provider.showBigPictureNotification,
  ),
  NotificationButtonConfig(
    label: _NotificationButtonLabels.media,
    onPressed: provider.showMediaNotification,
  ),
  NotificationButtonConfig(
    label: _NotificationButtonLabels.bigText,
    onPressed: provider.showBigTextNotification,
  ),
  NotificationButtonConfig(
    label: _NotificationButtonLabels.inbox,
    onPressed: provider.showInboxNotification,
  ),
  NotificationButtonConfig(
    label: _NotificationButtonLabels.messaging,
    onPressed: provider.showMessagingNotification,
  ),
  NotificationButtonConfig(
    label: _NotificationButtonLabels.messagingGroup,
    onPressed: provider.showMessagingGroupNotification,
  ),
  NotificationButtonConfig(
    label: _NotificationButtonLabels.actions,
    onPressed: provider.showNotificationWithActions,
  ),
  NotificationButtonConfig(
    label: _NotificationButtonLabels.grouped,
    onPressed: provider.showGroupedNotifications,
  ),
  NotificationButtonConfig(
    label: _NotificationButtonLabels.progress,
    onPressed: provider.showProgressNotification,
  ),
  NotificationButtonConfig(
    label: _NotificationButtonLabels.cancelAll,
    onPressed: provider.cancelAllNotifications,
  ),
];

class _NotificationButtonLabels {
  static const basic = '🔔 Basic Notification';
  static const bigPicture = '🖼️ Big Picture Notification';
  static const media = '🎵 Media Notification';
  static const bigText = '📝 Big Text Notification';
  static const inbox = '📥 Inbox Notification';
  static const messaging = '💬 Messaging Notification';
  static const messagingGroup = '👥 Messaging Group Notification';
  static const actions = '🎯 Notification with Actions';
  static const grouped = '📚 Grouped Notifications';
  static const progress = '⏳ Progress Bar Notification';
  static const cancelAll = '🗑️ Cancel All Notifications';
}
