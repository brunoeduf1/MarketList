

import 'package:bloc/bloc.dart';
import 'package:market_list_app/pages/cubits/product_states.dart';

class ProductCubit extends Cubit<ProductSate>{
  final List<String> _products = [];
  List<String> get products => _products;

  ProductCubit() : super(InitialProductState());

  Future<void> addProduct({required String product}) async{
    emit(LoadingProductState());

    await Future.delayed(const Duration(seconds: 1));

    if (_products.contains(product)){
      emit(ErrorProductState('O produto já foi adicionado'));
    } else{
      _products.add(product);
      emit(LoadedProductState(_products));
    }
  }

  Future<void> removeProduct({required int index}) async{
    emit(LoadingProductState());

    await Future.delayed(const Duration(seconds: 1));

    _products.removeAt(index);

    emit(LoadedProductState(_products));
  }
}