import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'routes/route_names.dart';
import 'package:provider/provider.dart';
import 'provider/getprovider.dart';
import 'src/firebase_messaging/service/firebase_service.dart';
import 'src/awesome_notification/service/awesome_service.dart';
import 'src/local_notification/service/local_notification_service.dart';
import 'src/onesignal/service/onesignal_service.dart';
import 'dart:developer';

/// Main entry point of the application
Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await FirebaseService.initializeFirebase();
    await FirebaseService().init(); 
    log('Firebase initialized successfully');

    // Initialize Awesome Notifications
    await AwesomeService().initialize();
    log('Awesome Notifications initialized successfully');

    // Initialize Flutter Local Notifications
    await NotificationService.initializeLocalNotifications();
    log('Flutter Local Notifications initialized successfully');

    // Initialize OneSignal
    await OneSignalService.initializeOneSignal();
    log('OneSignal initialized successfully');

    runApp(const MyApp());
  } catch (e, stack) {
    log('Error during app initialization: $e', stackTrace: stack);
    runApp(const MyApp()); // Still run the app even if initialization fails
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: getProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'New App',
        theme: ThemeData(
          fontFamily: 'Poppins',
          primarySwatch: Colors.deepPurple,
          useMaterial3: true,
        ),
        initialRoute: RouteNames.home,
        routes: AppRoutes.routes,
      ),
    );
  }
}
