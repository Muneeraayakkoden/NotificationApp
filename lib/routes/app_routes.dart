import 'package:flutter/material.dart';
import '../src/firebase_messaging/view/firebase_messaging.dart';
import '../src/local_notification/view/local_notification.dart';
import '../src/home.dart';
import 'route_names.dart';
import '../src/awesome_notification/view/awesome.dart';
import '../src/onesignal/view/onesignal_view.dart';


class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    RouteNames.localnotification: (context) => const LocalNotification(),
    RouteNames.firebaseMsg: (context) => const FirebaseMessagingView(),
    RouteNames.home: (context) => const HomePage(),
    RouteNames.awesome: (context) => const Awesome(),
    RouteNames.onesignal: (context) => const OneSignalView(),
  };
}
