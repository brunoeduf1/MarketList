// ignore_for_file: depend_on_referenced_packages
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_list_app/firebase_message_provider.dart';
import 'package:market_list_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:market_list_app/pages/home_page.dart';
import 'package:market_list_app/pages/notification_screen.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  await FirebaseApi().initNotifications();
  
  String? token = await FirebaseMessaging.instance.getToken();
  if (kDebugMode) {
    print(token);
  }

  runApp(ChangeNotifierProvider(
      create: (context) => PushNotificationProvider(),
      child: const MyApp(),
  ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Push Notification',
      navigatorKey: navigatorKey,
      home: const HomePage(),
      routes: {
        NotificationScreen.route: (context) => const NotificationScreen(),
        HomePage.route: (context) => const HomePage(),
      },
    );
  }
}
