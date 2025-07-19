import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/firebase_provider.dart';

class FirebaseMessagingView extends StatelessWidget {
  const FirebaseMessagingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseProvider>(
      builder: (context, provider, _) {
        if (!provider.isInitialized && !provider.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            provider.init();
          });
        }
        if (provider.isLoading || !provider.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Push Notification Error:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  provider.error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await provider.requestPermission();
                  },
                  child: const Text('Try Requesting Permission Again'),
                ),
                const SizedBox(height: 8),
                Text(
                  'If the issue persists, please enable notifications in your device system settings.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Push Notifications')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: provider.lastMessage == null
                ? const Center(
                    child: Text(
                      'No push notification received yet.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  )
                : AnimatedSwitcher(
                    duration: Duration(milliseconds: 350),
                    child: Column(
                      key: ValueKey(provider.lastMessage?.messageId),
                      children: [
                        Card(
                          color: Colors.white,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.notifications_active,
                                      color: Colors.deepPurple,
                                      size: 28,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        provider
                                                .lastMessage
                                                ?.notification
                                                ?.title ??
                                            'No Title',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  provider.lastMessage?.notification?.body ??
                                      'No Body',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Data:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple.shade700,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    provider.lastMessage?.data.toString() ??
                                        '{}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton.icon(
                          onPressed: () {
                            Provider.of<FirebaseProvider>(
                              context,
                              listen: false,
                            ).cancelAllNotifications();
                          },
                          icon: const Icon(Icons.cancel),
                          label: const Text('Cancel Notification'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 24,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
