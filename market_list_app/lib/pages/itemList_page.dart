import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ItemListPage extends StatelessWidget
{
  final RemoteMessage message;
  const ItemListPage({Key? key, required this.message}) : super(key: key);
  static const route = '/notification-screen';
  
  void _showDialogFromPushNotification(BuildContext context)
  {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message.notification!.title.toString()),
            content: Text(message.notification!.body.toString()),
            actions: [
              TextButton(
                onPressed: () {
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
  }

  @override
  Widget build(BuildContext context) {
    _showDialogFromPushNotification(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemplo com Scaffold'),
      ),
      body: const Center(
        child: Text(
          'Olá, mundo!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}