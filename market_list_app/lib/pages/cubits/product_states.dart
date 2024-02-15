abstract class ProductSate{}

class InitialProductState extends ProductSate {}

class LoadingProductState extends ProductSate{}

class LoadedProductState extends ProductSate{
  final List<String> products;

  LoadedProductState(this.products);
}

class ErrorProductState extends ProductSate {
  final String message;

  ErrorProductState(this.message);
}