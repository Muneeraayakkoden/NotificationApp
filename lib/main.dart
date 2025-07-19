import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'routes/route_names.dart';
import 'package:provider/provider.dart';
import 'provider/getprovider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'firebase_options.dart' show DefaultFirebaseOptions;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer';

/// Main entry point of the application
Future<void> main() async {
  try {
    await dotenv.load();
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();

    log('Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log('Firebase initialized successfully');

    // Initialize OneSignal
    await _initializeOneSignal();

    log('Starting application...');
    runApp(const MyApp());
  } catch (e, stack) {
    log('Error during app initialization: $e', stackTrace: stack);
    // Still run the app even if initialization fails
    runApp(const MyApp());
  }
}

/// Initialize OneSignal
Future<void> _initializeOneSignal() async {
  try {
    // Enable verbose logging for debugging (remove in production)
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    final String appId = dotenv.env['ONESIGNAL_APP_ID']!;
    // Initialize OneSignal
    OneSignal.initialize(appId);
    log('OneSignal initialized successfully');

    // Request notification permission
    OneSignal.Notifications.requestPermission(false);
    log('Notification permission requested');
  } catch (e, stack) {
    log('Error initializing OneSignal: $e', stackTrace: stack);
    // Don't rethrow as OneSignal is optional
  }
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
