import 'package:flutter/material.dart';
import '../service/local_notification_service.dart';
import '../provider/localnotification_provider.dart';

class LocalNotification extends StatefulWidget {
  const LocalNotification({super.key});

  @override
  State<LocalNotification> createState() => _LocalNotificationState();
}

class _LocalNotificationState extends State<LocalNotification> {
  late final NotificationService _service;
  late final NotificationProvider _provider;
  bool _isInitialized = false;
  String _statusMessage = 'Initializing...';
  bool permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _service = NotificationService();
    _provider = NotificationProvider(_service);
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      setState(() {
        _statusMessage = 'Initializing notification service...';
      });
      debugPrint('🔄 Starting notification initialization...');

      await _service.initialize();
      debugPrint('✅ Notification service initialized successfully');

      setState(() {
        _isInitialized = true;
        _statusMessage = 'Tap buttons to test notifications.';
      });
    } catch (e) {
      debugPrint('❌ Error initializing notifications: $e');
      debugPrint('❌ Stack trace: ${StackTrace.current}');
      setState(() {
        _isInitialized = true;
        _statusMessage = 'Initialization failed: $e';
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
        child: _isInitialized
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.deepPurple.shade200,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _statusMessage,
                            style: TextStyle(
                              fontSize: 16,
                              color: permissionsGranted
                                  ? Colors.green.shade700
                                  : Colors.black87,
                              fontWeight: permissionsGranted
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Check the console for debug messages.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
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

/// Notification button configuration for demo purposes
class NotificationButtonConfig {
  final String label;
  final VoidCallback onPressed;
  const NotificationButtonConfig({
    required this.label,
    required this.onPressed,
  });
}

/// Returns a list of notification button configs for demonstration
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

/// Widget that displays all notification demo buttons
class NotificationDemoButtons extends StatelessWidget {
  final NotificationProvider provider;
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

/// Helper widget for a single notification button
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
      child: ElevatedButton.icon(
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
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
      ),
    );
  }
}

/// Button label constants for maintainability
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
