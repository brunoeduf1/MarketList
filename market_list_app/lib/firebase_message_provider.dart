import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_list_app/notification.dart';
import 'package:market_list_app/pages/itemList_page.dart';
import 'package:provider/provider.dart';

Future<void> firebaseMessagingBackground(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message: ${message.notification?.title}");
  }
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(BuildContext context, RemoteMessage message)
  {
    if (message.data['key1'] == null) return;
    
    Navigator.push(context, MaterialPageRoute(builder: (context) => ItemListPage(message: message)));
  }

 @pragma('vm:entry-point')
  Future initPushNotifications(BuildContext context) async {

    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null){
      handleMessage(context, initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackground);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> initNotifications(BuildContext context) async {
    initPushNotifications(context);
    await _firebaseMessaging.requestPermission();
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