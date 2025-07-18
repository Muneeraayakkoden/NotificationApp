import 'package:flutter/material.dart';
import '../src/local_notification/view/local_notification.dart';
import '../src/home.dart';
import 'route_names.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    RouteNames.localnotification: (context) => const LocalNotification(),
    RouteNames.home: (context) => const HomePage(),
  };
}
