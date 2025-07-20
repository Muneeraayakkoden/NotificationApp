import 'package:flutter/material.dart';
import '../service/awesome_service.dart';

class AwesomeProvider with ChangeNotifier {
  final AwesomeService _notificationService = AwesomeService();

  // Methods to trigger different notification types
  Future<void> showBasicNotification() async {
    await _notificationService.showBasicNotification(
      title: 'Basic Notification',
      body: 'This is a basic notification example',
    );
  }

  Future<void> showBigPictureNotification() async {
    await _notificationService.showBigPictureNotification(
      title: 'Big Picture Notification',
      body: 'This is a big picture notification',
      bigPicture:'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
    );
  }

  Future<void> showMediaNotification() async {
    await _notificationService.showMediaNotification(
      title: 'Media Notification',
      body: 'This is a media notification',
    );
  }

  Future<void> showBigTextNotification() async {
    await _notificationService.showBigTextNotification(
      title: '🚀 Product Update: Version 2.0 Released!',
      bigText: '''
We are thrilled to announce the release of version 2.0!

Key Highlights:
• Brand new dark mode for comfortable night-time use
• 2x faster performance and smoother animations
• Enhanced security and privacy controls
• Bug fixes and stability improvements

How to update:
1. Open the app store
2. Search for our app
3. Tap "Update"

Thank you for being part of our community!

— The Dev Team
''',
    );
  }

  Future<void> showInboxNotification() async {
    await _notificationService.showInboxNotification(
      title: 'Inbox Notification',
      body: 'You have new messages',
      lines: [
        'Message 1: Hello there!',
        'Message 2: How are you?',
        'Message 3: Meeting at 3 PM',
      ],
    );
  }

  Future<void> showMessagingNotification() async {
    await _notificationService.showMessagingNotification(
      title: 'John Doe',
      body: 'Hey, how are you doing?',
      messages: [
        {
          'id': 1,
          'message': 'Hey there!',
          'date': DateTime.now().subtract(Duration(minutes: 30)),
        },
        {
          'id': 2,
          'message': 'How are you?',
          'date': DateTime.now().subtract(Duration(minutes: 15)),
        },
        {'id': 3, 'message': 'Can we meet tomorrow?', 'date': DateTime.now()},
      ],
    );
  }

  Future<void> showMessagingGroupNotification() async {
    await _notificationService.showMessagingGroupNotification(
      title: 'Team Chat',
      body: 'New messages in team chat',
      messages: [
        {
          'id': 1,
          'message': 'Alice: Good morning team!',
          'date': DateTime.now().subtract(Duration(minutes: 30)),
        },
        {
          'id': 2,
          'message': 'Bob: Hi Alice!',
          'date': DateTime.now().subtract(Duration(minutes: 15)),
        },
        {
          'id': 3,
          'message': 'Charlie: Let\'s meet at 2 PM',
          'date': DateTime.now(),
        },
      ],
      groupKey: 'team_chat',
    );
  }

  Future<void> showNotificationWithActions() async {
    await _notificationService.showNotificationWithActions(
      title: 'Action Required',
      body: 'Please respond to this notification',
    );
  }

  Future<void> showGroupedNotifications() async {
    await _notificationService.showGroupedNotifications(
      title: 'Grouped Notification 1',
      body: 'This is the first notification in the group',
      groupKey: 'my_group',
    );
    await Future.delayed(Duration(seconds: 1));
    await _notificationService.showGroupedNotifications(
      title: 'Grouped Notification 2',
      body: 'This is the second notification in the group',
      groupKey: 'my_group',
    );
  }

  Future<void> showProgressNotification() async {
    const int progressId = 1001; // Unique id for progress notification
    for (int i = 0; i <= 100; i += 10) {
      await _notificationService.showProgressNotification(
        title: i == 100 ? 'Downloaded' : 'Downloading',
        body: i == 100 ? 'Download complete.' : 'Download in progress...',
        progress: i,
        indeterminate: i == 0,
        id: progressId,
      );
      await Future.delayed(Duration(seconds: 1));
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
  }
}
