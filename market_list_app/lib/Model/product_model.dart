class Product
{
  int id;
  late bool isBought;
  late final String name;

  Product( {required this.name, this.isBought = false, this.id = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': name,
      'isBought': isBought
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['nome'],
      isBought: map['isBought']
    );
  }
}