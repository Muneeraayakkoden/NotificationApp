import 'package:flutter/material.dart';
import '../service/local_notification_service.dart';
import '../provider/localnotification_provider.dart';
import '../../widget/notification_button.dart';

class LocalNotification extends StatelessWidget {
  const LocalNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationService service = NotificationService();
    final NotificationProvider provider = NotificationProvider(service);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Local Notifications',
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
              const Column(
                  children: [
                    Text(
                      'Tap buttons to test notifications.',
                      style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                  ],
                ),
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
  NotificationProvider provider,
) => [
  NotificationButtonConfig(
    label: _NotificationButtonLabels.basic,
    onPressed: provider.showBasicNotification,
  ),
  NotificationButtonConfig(
    label: _NotificationButtonLabels.scheduled,
    onPressed: provider.showScheduledNotification,
  ),
  NotificationButtonConfig(
    label: _NotificationButtonLabels.progress,
    onPressed: provider.showProgressNotification,
  ),
  NotificationButtonConfig(
    label: _NotificationButtonLabels.action,
    onPressed: provider.showActionNotification,
  ),
  NotificationButtonConfig(
    label: _NotificationButtonLabels.grouped,
    onPressed: provider.showGroupedNotifications,
  ),
  NotificationButtonConfig(
    label: _NotificationButtonLabels.customSound,
    onPressed: provider.showCustomSoundNotification,
  ),
  NotificationButtonConfig(
    label: _NotificationButtonLabels.silent,
    onPressed: provider.showSilentNotification,
  ),
  NotificationButtonConfig(
    label: _NotificationButtonLabels.chronometer,
    onPressed: provider.showChronometerNotification,
  ),
  NotificationButtonConfig(
    label: _NotificationButtonLabels.cancelAll,
    onPressed: provider.cancelAllNotifications,
  ),
];

class _NotificationButtonLabels {
  static const basic = '🔔 Basic Notification';
  static const scheduled = '⏰ Scheduled Notification (5s)';
  static const progress = '📊 Progress Notification';
  static const action = '🎯 Interactive Actions';
  static const grouped = '👥 Grouped Messages';
  static const customSound = '🔊 Custom Sound';
  static const cancelAll = '🗑️ Cancel All Notifications';
  static const silent = '🔕 Silent Notification';
  static const chronometer = '⏱️ Chronometer Notification';
}
