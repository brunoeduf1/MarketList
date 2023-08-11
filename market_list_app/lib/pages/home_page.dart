import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../firebase_message_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const route = '/home-screen';

  @override
  ShoppingListState createState() => ShoppingListState();
}

class ShoppingItem {
  String name;
  bool isBought;
  ShoppingItem(this.name, this.isBought);
}

class ShoppingListState extends State<HomePage>{
  final List<ShoppingItem> _items = [];
  final List<ShoppingItem> _selectedItems = [];
  static String response = ""; 

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Future<void> initState() async {
    super.initState();

    await FirebaseApi().initNotifications(context);
    NotificationListenerProvider().getMessage(context);
    
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.data.isNotEmpty)
      {
        response = message.data['key1'];
      }
    });
  }

  void addItemToListFromPushNotification(RemoteMessage message) async
  {
    if (mounted) {
      setState(() {
        _items.add(ShoppingItem(message.data['key1'], false));
      });
    }
  }

  void _toggleItemBoughtStatus(int index) {
    setState(() {
      _items[index].isBought = !_items[index].isBought;
    });
  }

  void _toggleItemSelectedStatus(int index) {
    setState(() {
      if (_selectedItems.contains(_items[index])) {
        _selectedItems.remove(_items[index]);
      } else {
        _selectedItems.add(_items[index]);
      }
    });
  }

  void _deleteSelectedItems() {
    setState(() {
      _items.removeWhere((item) => _selectedItems.contains(item));
      _selectedItems.clear();
    });
  }

  void addItemToList(String itemName, ) {
    setState(() {
      _items.add(ShoppingItem(itemName, false));
    });
  }

  void _editItem(int index) async {
    String editedName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newName = _items[index].name;
        return AlertDialog(
          title: const Text('Item edit'),
          content: TextField(
            controller: TextEditingController(text: newName),
            onChanged: (value) {
              newName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newName.isNotEmpty) {
                  setState(() {
                    _items[index].name = newName;
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (editedName.isNotEmpty) {
      setState(() {
        _items[index] = ShoppingItem(editedName, false);
      });
    }
  }

  void _showDialogFromPushNotification(final message)
  {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message.notification?.title),
            content: Text(message.notification?.body),
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

  void _showAddItemDialog() {
    String itemName = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Item to List'),
          content: TextField(
            onChanged: (value) {
              itemName = value;
            },
            decoration: const InputDecoration(labelText: 'Item Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (itemName.isNotEmpty) {
                  addItemToList(itemName);
                }
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    bool? isAccepted = Provider.of<PushNotificationProvider>(context).isAccepted;
    if(isAccepted)
    {
      addItemToList(response);
      Provider.of<PushNotificationProvider>(context, listen: false).clearNotification();
    }

    var message = ModalRoute.of(context)!.settings.arguments;
    if(message != null)
    {
      _showDialogFromPushNotification(message);
      message = null;
    }
      
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      drawer: const Drawer(),
      body: ListView.separated(
        itemCount: _items.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.grey),
        itemBuilder: (context, index) {
          final item = _items[index];
          final isSelected = _selectedItems.contains(item);

          return ListTile(
            leading: Checkbox(
              value: isSelected,
              onChanged: (_) => _toggleItemSelectedStatus(index),
            ),
            title: Text(
              item.name,
              style: TextStyle(
                color: item.isBought ? Colors.red : null,
                decoration: item.isBought ? TextDecoration.lineThrough : null,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _editItem(index);
              },
            ),
            onTap: () => _toggleItemBoughtStatus(index),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _showAddItemDialog,
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                //_share();
              });
              },
            child: const Icon(Icons.share),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _selectedItems.isNotEmpty ? _deleteSelectedItems : null,
            backgroundColor: _selectedItems.isNotEmpty ? Colors.red : Colors.grey,
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
