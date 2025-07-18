import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../src/local_notification/provider/localnotification_provider.dart';
import '../src/local_notification/service/local_notification_service.dart';

List<SingleChildWidget> getProvider() {
  return [
    ChangeNotifierProvider(
      create: (context) => NotificationProvider(NotificationService()),
    ),
  ];
}
