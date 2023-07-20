import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class ShoppingItem {
  final String name;
  bool isBought;
  ShoppingItem(this.name, this.isBought);
}

class MyApp extends StatelessWidget {
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
  List<ShoppingItem> _items = [];
  List<ShoppingItem> _selectedItems = [];

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
          title: Text('Editar item'),
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
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (editedName != null && editedName.isNotEmpty) {
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
          title: Text('Add Item to List'),
          content: TextField(
            onChanged: (value) {
              itemName = value;
            },
            decoration: InputDecoration(labelText: 'Item Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (itemName.isNotEmpty) {
                  _addItemToList(itemName);
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
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
        title: Text('Shopping List'),
      ),
      body: ListView.separated(
        itemCount: _items.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey),
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
              icon: Icon(Icons.edit),
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
            child: Icon(Icons.add),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _selectedItems.isNotEmpty ? _deleteSelectedItems : null,
            child: Icon(Icons.delete),
            backgroundColor: _selectedItems.isNotEmpty ? Colors.red : Colors.grey,
          ),
        ],
      ),
    );
  }
}
