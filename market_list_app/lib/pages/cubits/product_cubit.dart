
import 'package:bloc/bloc.dart';
import 'package:market_list_app/pages/cubits/product_states.dart';

class ProductCubit extends Cubit<ProductSate>{
  final List<Product> _products = [];
  List<Product> get products => _products;
  late List<String> productList;
  
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
          _products.add(Product(item, false));
        }
      }

      emit(LoadedProductState(_products));
    }
  }

  Future<void> removeProduct({required int index}) async{
    emit(LoadingProductState());

    await Future.delayed(const Duration(seconds: 1));

    _products.removeAt(index);

    emit(LoadedProductState(_products));
  }

  Future<void> updateProduct({required int index, required String productName}) async{
    emit(LoadingProductState());

    await Future.delayed(const Duration(seconds: 1));

    _products[index] = Product(productName, false);

    emit(LoadedProductState(_products));
  }
}

class Product
{
  late bool isBought;
  late final String name;

  Product(this.name, this.isBought);
}