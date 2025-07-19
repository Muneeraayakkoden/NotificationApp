import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../provider/firebase_messaging_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// View for Firebase Cloud Messaging functionality
class FirebaseMessagingView extends StatefulWidget {
  const FirebaseMessagingView({super.key});

  @override
  State<FirebaseMessagingView> createState() => _FirebaseMessagingViewState();
}

class _FirebaseMessagingViewState extends State<FirebaseMessagingView> {
  @override
  void initState() {
    super.initState();
    _initializeMessaging();
  }

  /// Initialize messaging provider
  void _initializeMessaging() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<FirebaseMessagingProvider>(
        context,
        listen: false,
      );
      if (!provider.isInitialized) {
        provider.initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Firebase Messaging'),
      backgroundColor: Colors.deepPurple.shade700,
      foregroundColor: Colors.white,
      elevation: 2,
      actions: [
        Consumer<FirebaseMessagingProvider>(
          builder: (context, provider, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Analytics summary in app bar
                if (provider.isInitialized)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      provider.getAnalyticsSummary(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                // Refresh button
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: provider.isLoading ? null : () {
                    provider.refreshToken();
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// Build main body
  Widget _buildBody() {
    return Consumer<FirebaseMessagingProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return _buildLoadingWidget();
        }

        if (provider.error != null) {
          return _buildErrorWidget(provider);
        }

        return _buildContentWidget(provider);
      },
    );
  }

  /// Build loading widget
  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Initializing Firebase Messaging...'),
        ],
      ),
    );
  }

  /// Build error widget
  Widget _buildErrorWidget(FirebaseMessagingProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              provider.error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: provider.initialize,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  /// Build content widget
  Widget _buildContentWidget(FirebaseMessagingProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnalyticsSection(provider),
          const SizedBox(height: 16),
          _buildTokenSection(provider),
          const SizedBox(height: 16),
          _buildLatestMessageSection(provider),
          const SizedBox(height: 16),
          _buildQuickActionsSection(provider),
          const SizedBox(height: 16),
          _buildMessageHistorySection(provider),
        ],
      ),
    );
  }

  /// Build token section
  Widget _buildTokenSection(FirebaseMessagingProvider provider) {
    return _buildSectionCard(
      title: 'FCM Token',
      icon: Icons.token,
      child: _buildTokenWidget(provider.token),
    );
  }

  /// Build latest message section
  Widget _buildLatestMessageSection(FirebaseMessagingProvider provider) {
    return _buildSectionCard(
      title: 'Latest Message',
      icon: Icons.message,
      child: _buildMessageWidget(provider.lastMessage),
    );
  }

  /// Build analytics section
  Widget _buildAnalyticsSection(FirebaseMessagingProvider provider) {
    final analytics = provider.getNotificationAnalytics();
    return _buildSectionCard(
      title: 'Notification Analytics',
      icon: Icons.analytics,
      child: _buildAnalyticsWidget(analytics, provider),
    );
  }

  /// Build quick actions section
  Widget _buildQuickActionsSection(FirebaseMessagingProvider provider) {
    return _buildSectionCard(
      title: 'Quick Actions',
      icon: Icons.flash_on,
      child: _buildQuickActionsWidget(provider),
    );
  }

  /// Build message history section
  Widget _buildMessageHistorySection(FirebaseMessagingProvider provider) {
    return _buildSectionCard(
      title: 'Message History (${provider.messageCount})',
      icon: Icons.history,
      child: _buildMessageHistoryWidget(provider),
    );
  }

  /// Build section card
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  /// Build token widget
  Widget _buildTokenWidget(String? token) {
    if (token == null) {
      return const Text(
        'Fetching token...',
        style: TextStyle(color: Colors.grey),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          token,
          style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.copy, size: 16),
              onPressed: () => _copyToClipboard(token),
              tooltip: 'Copy Token',
            ),
            const Text('Tap to copy', style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }

  /// Build message widget
  Widget _buildMessageWidget(RemoteMessage? message) {
    if (message == null) {
      return const Text(
        'No message received yet.',
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.notification?.title != null)
          _buildMessageField('Title', message.notification!.title!),
        if (message.notification?.body != null)
          _buildMessageField('Body', message.notification!.body!),
        if (message.data.isNotEmpty)
          _buildMessageField('Data', message.data.toString()),
        if (message.messageId != null)
          _buildMessageField('Message ID', message.messageId!),
        _buildMessageField('Timestamp', DateTime.now().toString()),
      ],
    );
  }

  /// Build message history widget
  Widget _buildMessageHistoryWidget(FirebaseMessagingProvider provider) {
    if (provider.messageHistory.isEmpty) {
      return const Text(
        'No messages in history.',
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${provider.messageCount} messages'),
            TextButton(
              onPressed: provider.clearMessageHistory,
              child: const Text('Clear History'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: provider.messageHistory.length,
            itemBuilder: (context, index) {
              final message = provider.messageHistory[index];
              return _buildHistoryItem(message, index);
            },
          ),
        ),
      ],
    );
  }

  /// Build history item
  Widget _buildHistoryItem(RemoteMessage message, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.shade100,
          child: Text('${index + 1}'),
        ),
        title: Text(
          message.notification?.title ?? 'No Title',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          message.notification?.body ?? 'No Body',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _showMessageDetails(message),
      ),
    );
  }

  /// Build message field
  Widget _buildMessageField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }

  /// Build floating action button
  Widget? _buildFloatingActionButton() {
    return Consumer<FirebaseMessagingProvider>(
      builder: (context, provider, _) {
        return FloatingActionButton(
          onPressed: () => _showTopicDialog(provider),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          child: const Icon(Icons.topic),
        );
      },
    );
  }

  /// Build analytics widget
  Widget _buildAnalyticsWidget(Map<String, dynamic> analytics, FirebaseMessagingProvider provider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildAnalyticsCard(
                'Received',
                analytics['total_received'].toString(),
                Icons.inbox,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildAnalyticsCard(
                'Opened',
                analytics['total_opened'].toString(),
                Icons.open_in_new,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildAnalyticsCard(
                'Open Rate',
                '${analytics['open_rate']}%',
                Icons.trending_up,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildAnalyticsCard(
                'Dismissed',
                analytics['total_dismissed'].toString(),
                Icons.close,
                Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              provider.resetAnalytics();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Analytics reset successfully')),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reset Analytics'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade100,
              foregroundColor: Colors.deepPurple,
            ),
          ),
        ),
      ],
    );
  }

  /// Build analytics card
  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  /// Build quick actions widget
  Widget _buildQuickActionsWidget(FirebaseMessagingProvider provider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => provider.sendTestNotification(),
                icon: const Icon(Icons.send),
                label: const Text('Send Test'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => provider.refreshToken(),
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Token'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showTopicDialog(provider),
                icon: const Icon(Icons.topic),
                label: const Text('Subscribe Topic'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showUnsubscribeDialog(provider),
                icon: const Icon(Icons.unsubscribe),
                label: const Text('Unsubscribe'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showNotificationTestDialog(provider),
            icon: const Icon(Icons.notifications_active),
            label: const Text('Advanced Notification Test'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade600,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  /// Copy to clipboard
  void _copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Token copied to clipboard!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to copy: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Show message details
  void _showMessageDetails(RemoteMessage message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Message Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message.notification?.title != null)
                _buildMessageField('Title', message.notification!.title!),
              if (message.notification?.body != null)
                _buildMessageField('Body', message.notification!.body!),
              if (message.data.isNotEmpty)
                _buildMessageField('Data', message.data.toString()),
              if (message.messageId != null)
                _buildMessageField('Message ID', message.messageId!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Show topic dialog
  void _showTopicDialog(FirebaseMessagingProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Subscribe to Topic'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Topic Name',
            hintText: 'Enter topic name (e.g., news, updates)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                provider.subscribeToTopic(controller.text);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Subscribed to topic: ${controller.text}')),
                );
              }
            },
            child: const Text('Subscribe'),
          ),
        ],
      ),
    );
  }

  /// Show unsubscribe dialog
  void _showUnsubscribeDialog(FirebaseMessagingProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsubscribe from Topic'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Topic Name',
            hintText: 'Enter topic name to unsubscribe',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                provider.unsubscribeFromTopic(controller.text);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Unsubscribed from topic: ${controller.text}')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Unsubscribe'),
          ),
        ],
      ),
    );
  }

  /// Show advanced notification test dialog
  void _showNotificationTestDialog(FirebaseMessagingProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Advanced Notification Test'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Test different notification scenarios:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTestButton(
                'Test Foreground Notification',
                'Simulates a notification while app is open',
                Icons.notifications_active,
                Colors.blue,
                () => _simulateForegroundNotification(provider),
              ),
              const SizedBox(height: 8),
              _buildTestButton(
                'Test Data-Only Message',
                'Simulates a message with only data payload',
                Icons.data_object,
                Colors.green,
                () => _simulateDataOnlyMessage(provider),
              ),
              const SizedBox(height: 8),
              _buildTestButton(
                'Test High Priority Message',
                'Simulates a high priority notification',
                Icons.priority_high,
                Colors.orange,
                () => _simulateHighPriorityMessage(provider),
              ),
              const SizedBox(height: 16),
              const Text(
                'Note: These are simulations for testing UI behavior. Real notifications come from Firebase Console or your backend.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Build test button
  Widget _buildTestButton(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(description, style: const TextStyle(fontSize: 12)),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(12),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }

  /// Simulate foreground notification
  void _simulateForegroundNotification(FirebaseMessagingProvider provider) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Simulated foreground notification - Check your notification panel!'),
        backgroundColor: Colors.blue,
      ),
    );
    // In a real app, this would trigger the local notification service
  }

  /// Simulate data-only message
  void _simulateDataOnlyMessage(FirebaseMessagingProvider provider) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Simulated data-only message - Check console logs!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Simulate high priority message
  void _simulateHighPriorityMessage(FirebaseMessagingProvider provider) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Simulated high priority message - Should bypass DND!'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
