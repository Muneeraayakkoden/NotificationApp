import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/awesome_provider.dart';

class Awesome extends StatefulWidget {
  const Awesome({super.key});

  @override
  State<Awesome> createState() => _AwesomeState();
}

class _AwesomeState extends State<Awesome> {
  late final AwesomeProvider _provider;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<AwesomeProvider>(context, listen: false);
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      await _provider.initializeNotifications();
      setState(() {
        _isInitialized = true;
       
      });
    } catch (e) {
      setState(() {
        _isInitialized = true;
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
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
        child: _isInitialized
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    NotificationDemoButtons(provider: _provider),
                  ],
                ),
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.deepPurple),
                    SizedBox(height: 16),
                    Text(
                      'Initializing notifications...',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class NotificationButtonConfig {
  final String label;
  final VoidCallback onPressed;
  const NotificationButtonConfig({
    required this.label,
    required this.onPressed,
  });
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

class NotificationDemoButtons extends StatelessWidget {
  final AwesomeProvider provider;
  const NotificationDemoButtons({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final configs = getNotificationButtonConfigs(provider);
    return Column(
      children: configs
          .map(
            (config) => _NotificationButton(
              label: config.label,
              onPressed: config.onPressed,
            ),
          )
          .toList(),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _NotificationButton({required this.label, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade400, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.9),
          foregroundColor: Colors.deepPurple.shade700,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

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
