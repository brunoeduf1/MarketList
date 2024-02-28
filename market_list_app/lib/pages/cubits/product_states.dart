import 'package:market_list_app/Model/product_model.dart';

abstract class ProductSate{}

class InitialProductState extends ProductSate {}

class LoadingProductState extends ProductSate{}

class LoadedProductState extends ProductSate{
  final List<Product> products;

  LoadedProductState(this.products);
}

class ErrorProductState extends ProductSate {
  final String message;

  ErrorProductState(this.message);
}