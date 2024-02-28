import 'package:bloc/bloc.dart';
import 'package:market_list_app/Model/product_model.dart';
import 'package:market_list_app/database/database.dart';
import 'package:market_list_app/pages/cubits/product_states.dart';

class ProductCubit extends Cubit<ProductSate>{
  late List<Product> _products = [];
  List<Product> get products => _products;
  late List<String> productList;
  late List<String> productListDb;
  
  ProductCubit() : super(InitialProductState());

  Future<void> addProduct({required Product product}) async{
    emit(LoadingProductState());

    await Future.delayed(const Duration(seconds: 1));

    if (_products.contains(product)){
      emit(ErrorProductState('O produto já foi adicionado'));
    } 
    
    else{
      productList = product.name.split('\n');

      for (String item in productList)
      {
        if(item.isNotEmpty) {
          await DatabaseHelper.instance.insert(Product(name: item));
          _products.add(Product(name: item));       
        }
      }

      emit(LoadedProductState(_products));
    }
  }

  Future<void> removeProduct({required int index}) async{
    emit(LoadingProductState());

    await Future.delayed(const Duration(seconds: 1));

    await DatabaseHelper.instance.delete(index);
    _products = await DatabaseHelper.instance.getAllProducts();

    emit(LoadedProductState(_products));
  }

  Future<void> updateProduct({required int index, required String productName}) async{
    emit(LoadingProductState());

    await Future.delayed(const Duration(seconds: 1));

    await DatabaseHelper.instance.update(Product(name: productName, id: index));
    _products = await DatabaseHelper.instance.getAllProducts();

    emit(LoadedProductState(_products));
  }

  Future<List<Product>> getAllProducts() async{
    emit(LoadingProductState());

    await Future.delayed(const Duration(seconds: 1));

    _products = await DatabaseHelper.instance.getAllProducts();

    emit(LoadedProductState(_products));

    return _products;
  }
}