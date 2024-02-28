import 'dart:async';
import 'package:market_list_app/Model/product_model.dart';
import 'package:market_list_app/pages/cubits/product_cubit.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "product02.db";
  static const _databaseVersion = 1;

  static const table = 'product';

  static const columnId = 'id';
  static const columnName = 'nome';
  static const columnIsBought = 'isBought';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT,
        $columnIsBought INTEGER
      )
    ''');
  }

  Future<int> insert(Product product) async {
    Database db = await instance.database;
    return await db.insert(table, product.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> update(Product product) async {
    Database db = await instance.database;
    await db.update(table, product.toMap(), where: '$columnId = ?', whereArgs: [product.id]);
  }

  Future<List<Product>> getAllProducts() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (index) {
      return Product.fromMap(maps[index]);
    });
  }
}