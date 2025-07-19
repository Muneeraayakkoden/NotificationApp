import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'routes/route_names.dart';
import 'package:provider/provider.dart';
import 'provider/getprovider.dart';
import 'firebase_options.dart' show DefaultFirebaseOptions;
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';


/// Main entry point of the application
Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log('Firebase initialized successfully');


    runApp(const MyApp());
  } catch (e, stack) {
    log('Error during app initialization: $e', stackTrace: stack);
    // Still run the app even if initialization fails
    runApp(const MyApp());
  }
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic group',
      ),
    ],
    debug: true,
  );
}

/// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: getProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Demo App',
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
