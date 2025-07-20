import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/firebase_provider.dart';

class FirebaseMessagingView extends StatelessWidget {
  const FirebaseMessagingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Push Notifications',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.deepPurple.shade700,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
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
                                    color: Colors.deepPurple.withValues(
                                      alpha: 0.05,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    provider.lastMessage?.data.toString() ??
                                        'Not Available',
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
                          label: const Text('Clear'),
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
