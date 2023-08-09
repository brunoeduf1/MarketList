import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationScreen extends StatelessWidget
{
  const NotificationScreen({Key? key}) : super(key: key);
  static const route = '/notification-screen';
  
  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments;
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