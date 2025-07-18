import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'routes/route_names.dart';
import 'package:provider/provider.dart';
import 'provider/getprovider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '.env';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Enable verbose logging for debugging (remove in production)
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(ONESIGNAL_APP_ID);
  // Remove this method after testing and instead use In-App Messages to prompt for notification permission.
  OneSignal.Notifications.requestPermission(false);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: getProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Demo App',
        theme: ThemeData(fontFamily: 'Poppins'),
        initialRoute: RouteNames.home,
        routes: AppRoutes.routes,
      ),
    );
  }
}
