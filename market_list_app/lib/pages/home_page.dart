import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:market_list_app/Model/product_model.dart';
import 'package:market_list_app/pages/cubits/product_cubit.dart';
import 'package:market_list_app/pages/cubits/product_states.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  late final List<Product> _items = [];

  late final ProductCubit cubit;
  final TextEditingController _itemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<ProductCubit>(context);
    cubit.stream.listen((state) {
      if (state is ErrorProductState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.message)));
      }
    });
  }

  void _toggleItemBoughtStatus(int index, List<Product> products) {
    products[index].isBought == 1
        ? products[index].isBought = 0
        : products[index].isBought = 1;

    cubit.updateProduct(
        product: products[index],
        name: products[index].name,
        isBought: products[index].isBought,
        indx: index);
  }

  void _clearListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear list'),
          content: const Text('Deseja excluir todos os itens da lista?'),
          actions: [
            TextButton(
              onPressed: () {
                cubit.clearList();
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
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

  void _editItemDialog(int index, List<Product> products) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newName = products[index].name;
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
                  cubit.updateProduct(
                      product: products[index],
                      name: newName,
                      indx: index,
                      isBought: products[index].isBought);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List',
            style: TextStyle(
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
              onPressed: () => {_clearListDialog()},
              icon: const Icon(Icons.delete),
              color: Colors.grey[300]),
        ],
      ),
      body: Stack(
        children: [
          BlocBuilder(
            bloc: cubit,
            builder: (context, state) {
              if (state is InitialProductState) {
                cubit.getAllProducts();
                return _buildProductList(context, cubit.products);
              } else if (state is LoadingProductState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is LoadedProductState) {
                return _buildProductList(context, state.products);
              } else {
                return _buildProductList(context, cubit.products);
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
                child: Row(children: [
                  Expanded(
                    child: TextFormField(
                      controller: _itemController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Insert a product',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      cubit.addProduct(
                          product: Product(
                              name: _itemController.text, indx: _items.length));
                      _itemController.clear();
                    },
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(BuildContext context, List<Product> products) {
    return ReorderableListView(
      padding: const EdgeInsets.only(bottom: 100.0),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = products.removeAt(oldIndex);
          products.insert(newIndex, item);

          int updatedIntex = 0;
          for (Product item in products) {
            cubit.updateProductIndex(product: item, newIndex: updatedIntex);
            updatedIntex++;
          }
        });
      },
      children: List.generate(
        products.length,
        (index) {
          products.sort((a, b) => a.indx.compareTo(b.indx));
          final item = products[index];
          return Card(
            elevation: 5.0,
            key: Key(index.toString()),
            child: Slidable(
              
              key: Key(index.toString()),
              startActionPane: ActionPane(
                motion: const BehindMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {

                      List<Product> oldProductList = products;
                      cubit.removeProduct(product: products[index]);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                const TextSpan(text: 'O item '),
                                TextSpan(
                                  text: oldProductList[index].name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(text: ' foi excluído'),
                              ],
                            ),
                          ),
                          action: SnackBarAction(
                            label: 'Desfazer',
                            onPressed: () => {
                              cubit.restoreOldProductList(oldProductList),
                            },
                          ),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const BehindMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) => _editItemDialog(index, products),
                    backgroundColor: const Color(0xFF0392CF),
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                ],
              ),
              child: GestureDetector(
                key: Key(index.toString()),
                onTap: () {
                  _toggleItemBoughtStatus(index, products);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    child: Center(child: Text(products[index].name[0])),
                  ),
                  title: Text(
                    products[index].name,
                    style: TextStyle(
                      color: item.isBought == 1 ? Colors.red : null,
                      decoration: item.isBought == 1
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
