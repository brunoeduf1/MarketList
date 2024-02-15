import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_list_app/pages/cubits/product_cubit.dart';
import 'package:market_list_app/pages/cubits/product_states.dart';
import 'package:provider/provider.dart';
import '../firebase_message_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required  this.title});
  static const route = '/home-screen';

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

/*class ShoppingItem {
  String name;
  bool isBought;
  ShoppingItem(this.name, this.isBought);
}*/

class _MyHomePageState extends State<HomePage>{
  /*final List<ShoppingItem> _items = [];
  final List<ShoppingItem> _selectedItems = [];
  static String response = ""; 

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;*/

  late final ProductCubit cubit;
  final TextEditingController _itemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<ProductCubit>(context);
    cubit.stream.listen((state){
      if (state is ErrorProductState){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message))
        );
      }
    });
    //FirebaseApi().initNotifications(context);
    //NotificationListenerProvider().getMessage(context);
  }

  /*void addItemToListFromPushNotification(RemoteMessage message) async
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

  void _editItem(int index) {
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
  }*/

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: Stack(
        children: [
          BlocBuilder(
            bloc: cubit,
            builder: (context, state){
              if (state is InitialProductState){
                return const Center(
                  child: Text('Nenhum produto foi adicionado ainda'),
                  );
              } else if (state is LoadingProductState){
                return const Center(
                  child: CircularProgressIndicator(),
                  );
              } else if (state is LoadedProductState){
                return _buildProductList(state.products);
              } else {
                  return _buildProductList(cubit.products);
              }
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.03),
                    offset: const Offset(0, -0.5),
                    blurRadius: 4,
                  )
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _itemController,
                        decoration: InputDecoration(
                          hintText: 'Insert a product',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        cubit.addProduct(product: _itemController.text);
                        _itemController.clear();
                      },
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Center(
                          child: Icon(
                          Icons.add,
                          color: Colors.white,
                          )
                        ),
                      ),
                    )
                  ]),
              )
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProductList(List<String> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (_, index) {
        return ListTile(
          leading: CircleAvatar(
            child: Center(child: Text(products[index][0])),
          ),
          title: Text(products[index]),
          trailing: IconButton(
            onPressed: () {
              cubit.removeProduct(index: index);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red), 
            ),
        );
      },
    );
  }
}
