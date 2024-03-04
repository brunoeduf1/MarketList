class Product
{
  int? id;
  late int indx;
  late int isBought;
  late String name;

  Product({required this.name, this.isBought = 0, this.id, required this.indx});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': name,
      'isBought': isBought,
      'indx': indx
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['nome'],
      isBought: map['isBought'],
      indx: map['indx']
    );
  }
}