import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../src/local_notification/provider/localnotification_provider.dart';
import '../src/local_notification/service/local_notification_service.dart';
import '../src/firebase_messaging/provider/firebase_provider.dart';
import '../src/awesome_notification/provider/awesome_provider.dart';
import '../src/onesignal/provider/onesignal_provider.dart';

List<SingleChildWidget> getProvider() {
  return [
    ChangeNotifierProvider(create: (context) => NotificationProvider(NotificationService())),
    ChangeNotifierProvider(create: (context) => FirebaseProvider()),
    ChangeNotifierProvider(create: (context) => AwesomeProvider()),
    ChangeNotifierProvider(create: (context) => OnesignalProvider()),
  ];
}
