import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../firebase_message_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class ShoppingItem {
  String name;
  bool isBought;
  ShoppingItem(this.name, this.isBought);
}

class _ShoppingListState extends State<HomePage> {

  final List<ShoppingItem> _items = [];
  final List<ShoppingItem> _selectedItems = [];

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    NotificationListenerProvider().getMessage(context);
    print("dkfkdfkdjfdkfdfdfdfd");
    getToken();
  }

  void getToken() async {
    final token = await _firebaseMessaging.getToken();
    print("dlllllllllllllllll $token");
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

  void _addItemToList(String itemName) {
    setState(() {
      _items.add(ShoppingItem(itemName, false));
    });
  }

  /*Future<void> _share() async {
    await WhatsappShare.share(
      text: 'Whatsapp share text',
      linkUrl: 'https://flutter.dev/',
      phone: '911234567890',
    );
  }*/

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
                  _addItemToList(itemName);
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
