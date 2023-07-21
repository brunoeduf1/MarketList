import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class ShoppingItem {
  final String name;
  bool isBought;
  ShoppingItem(this.name, this.isBought);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShoppingList(),
    );
  }
}

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final List<ShoppingItem> _items = [];
  final List<ShoppingItem> _selectedItems = [];

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

  void _editItem(int index) async {
    String editedName = await showDialog(
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
                Navigator.pop(context, newName);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
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
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (itemName.isNotEmpty) {
                  _addItemToList(itemName);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
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
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'my_lists') {
                // Ação para a opção "My lists"
              } else if (value == 'config') {
                // Ação para a opção "Config"
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'my_lists',
                child: Text('Saved lists'),
              ),
              const PopupMenuItem<String>(
                value: 'config',
                child: Text('Settings'),
              ),
            ],
          ),
        ],
      ),
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
            onPressed: _selectedItems.isNotEmpty ? _deleteSelectedItems : null,
            backgroundColor: _selectedItems.isNotEmpty ? Colors.red : Colors.grey,
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
