import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_list_app/main.dart';
import 'package:market_list_app/notification.dart';
import 'package:market_list_app/pages/home_page.dart';
import 'package:market_list_app/pages/notification_screen.dart';
import 'package:path/path.dart';

import 'package:provider/provider.dart';


Future<void> firebaseMessagingBackground(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message: ${message.notification?.title}");
  }
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage? message)
  {
    if (message == null) return;
    
    navigatorKey.currentState?.pushNamed(
      NotificationScreen.route,
      arguments: message,
    );
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackground);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    
    initPushNotifications();
  }
}

class PushNotificationProvider with ChangeNotifier {
  bool _isAccepted = false;
  bool get isAccepted => _isAccepted;

  void acceptNotification(bool value) {
    _isAccepted = value;
    notifyListeners();
  }

  void clearNotification() {
    _isAccepted = false;
  }
}

class NotificationListenerProvider {
  //final _firebaseMessaging = FirebaseMessaging.instance.getInitialMessage();

  getMessage(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    RemoteNotification notification = event.notification!;

    //AppleNotification apple = event.notification!.apple!;
    AndroidNotification androidNotification = event.notification!.android!;

    sendNotification(title: notification.title!, body: notification.body);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(notification.title!),
            content: Text(notification.body!),
            actions: [
              TextButton(
                onPressed: () {
                  Provider.of<PushNotificationProvider>(context, listen: false).acceptNotification(true);
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
              TextButton(
                onPressed: () {   
                  Navigator.of(context).pop();  
                },
                child: const Text('Cancel'),
              ),
            ],
          );
      });
    });
  }
}