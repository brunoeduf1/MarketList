// ignore_for_file: depend_on_referenced_packages
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_list_app/firebase_message_provider.dart';
import 'package:market_list_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:market_list_app/pages/home_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
