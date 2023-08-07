import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:market_list_app/notification.dart';
import 'package:market_list_app/pages/home_page.dart';
import 'package:provider/provider.dart';

class PushNotificationProvider with ChangeNotifier {
  bool _isAccepted = false;

  // Método para obter o resultado do clique do botão 'Aceitar'.
  bool get isAccepted => _isAccepted;

  // Método para atualizar o estado do clique do botão 'Aceitar'.
  void acceptNotification(bool value) {
    _isAccepted = value;
    notifyListeners();
    _isAccepted = false; // Notifica os ouvintes (widgets que estão escutando as mudanças).
  }
}

class NotificationListenerProvider {
  final _firebaseMessaging = FirebaseMessaging.instance.getInitialMessage();

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
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                },
                child: const Text('Add'),
              ),
              TextButton(
                onPressed: () async {
                  Provider.of<PushNotificationProvider>(context, listen: false).acceptNotification(false);         
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