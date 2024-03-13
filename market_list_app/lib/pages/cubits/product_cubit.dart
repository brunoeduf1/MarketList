import 'package:bloc/bloc.dart';
import 'package:market_list_app/Model/product_model.dart';
import 'package:market_list_app/database/database.dart';
import 'package:market_list_app/pages/cubits/product_states.dart';

class ProductCubit extends Cubit<ProductSate>{
  late List<Product> _products = [];
  List<Product> get products => _products;
  late List<String> productList;
  
  ProductCubit() : super(InitialProductState());

  Future<void> addProduct({required Product product}) async{
    emit(LoadingProductState());

    await Future.delayed(const Duration(seconds: 1));

    _products = await DatabaseHelper.instance.getAllProducts();
    int indx = _products.length;

    if (_products.contains(product)){
      emit(ErrorProductState('O produto já foi adicionado'));
    } 

    else{
      productList = product.name.split('\n');

      for (String item in productList)
      {
        if(item.isNotEmpty) {
          await DatabaseHelper.instance.insert(Product(name: item, indx: indx));
          indx ++;   
        }
      }

      _products = await DatabaseHelper.instance.getAllProducts();
      emit(LoadedProductState(_products));
    }
  }

  Future<void> removeProduct({required Product product}) async{

    await DatabaseHelper.instance.delete(product);
    _products = await DatabaseHelper.instance.getAllProducts();

    emit(LoadedProductState(_products));
  }

  Future<void> clearList() async{

    for(Product item in _products){
      await DatabaseHelper.instance.delete(item);
    }

     _products = await DatabaseHelper.instance.getAllProducts();

    emit(LoadedProductState(_products));
  }

  Future<void> updateProduct({required Product product, required String name, required isBought, required indx}) async{

    product.name = name;
    product.isBought = isBought;
    product.indx = indx;

    await DatabaseHelper.instance.updateItem(product);  
    _products = await DatabaseHelper.instance.getAllProducts();

    emit(LoadedProductState(_products));
  }

  Future<void> updateProductIndex({required Product product, required int newIndex}) async{
    
    product.indx = newIndex;

    await DatabaseHelper.instance.updateItem(product);  
    _products = await DatabaseHelper.instance.getAllProducts();

    emit(LoadedProductState(_products));
  }

  Future<void> restoreOldProductList(List<Product> oldProductList) async{

    emit(LoadingProductState());

    await Future.delayed(const Duration(seconds: 1));

    clearList();

    for(Product item in oldProductList){
      await DatabaseHelper.instance.insert(item);
    }

    _products = await DatabaseHelper.instance.getAllProducts();

    emit(LoadedProductState(_products));
  }

  Future<List<Product>> getAllProducts() async{

    _products = await DatabaseHelper.instance.getAllProducts();

    emit(LoadedProductState(_products));

    return _products;
  }
}