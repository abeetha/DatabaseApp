import 'dart:io';
import 'package:database_app/product.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ProductDBHelper {

  static String path;
  static final _databaseName = "mydb.db";
  static final _databaseVersion = 1;

  static final _table_products = 'products';

  ProductDBHelper._privateConstructor();

  static final ProductDBHelper instance = ProductDBHelper._privateConstructor();

  static Database _database;



  /////// Returns Database whether its there or it initilize the database
  Future get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

///// Initialize db /////////
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

////// Create table
  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE products ( id INTEGER PRIMARY KEY autoincrement ,'
            ' name TEXT , price TEXT , quantity INTEGER)');
  }

/////// Insert product ....
  Future insertProduct(Product product) async {
    Database db = await instance.database;
    return await db.insert(_table_products, Product.toMap(product),
        conflictAlgorithm: ConflictAlgorithm.ignore
    );
  }

  //////// Get All product List ( Map -> Object List )
  Future <List<Product>> getProductsList() async {
    Database db = await instance.database;

    List<Map> productMaps = await db.query("products");
    print(productMaps);
    return Product.toList(productMaps);
  }
  //////// Update product
  Future<Product> updateProduct(Product product) async{

    Database db = await instance.database;

    db.update(_table_products, Product.toMap(product), where: "id = ?"  ,
        whereArgs: [ product.id] );

    return product;
  }
  //// Delete Product
  Future deleteProduct(Product product) async{

    Database db = await instance.database;
    var deleteProduct = db.delete(_table_products , where: "id = ?" ,
        whereArgs: [product.id]);

    return deleteProduct;
  }

}
