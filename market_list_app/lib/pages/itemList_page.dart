import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:market_list_app/firebase_message_provider.dart';
import 'package:provider/provider.dart';

class ItemListPage extends StatefulWidget
{
  final RemoteMessage? message;
  const ItemListPage({Key? key, this.message}) : super(key: key);
  static const route = '/itemlist-screen';

  @override
  ItemListState createState() => ItemListState();
}

class ItemListState extends State<ItemListPage>
{
  @override
  void initState() {
    super.initState();
    NotificationListenerProvider().getMessage(context);
  }

  void _showDialogFromPushNotification(BuildContext context)
  {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(widget.message!.notification!.title.toString()),
            content: Text(widget.message!.notification!.body.toString()),
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

    bool? isAccepted = Provider.of<PushNotificationProvider>(context).isAccepted;
    Provider.of<PushNotificationProvider>(context, listen: false).clearNotification();
    if(isAccepted)
    {
      var message = Provider.of<PushNotificationProvider>(context).message;
      //addItemToList(message.data['key1']);
    }
    else
    {
      setState(() {
        _showDialogFromPushNotification(context);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemplo com Scaffold'),
      ),
      body: const Center(
        child: Text(
          'Hello world!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
  

  

