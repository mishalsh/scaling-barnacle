
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'larry_soft.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        price REAL,
        imageUrl TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE cart(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER,
        name TEXT,
        price REAL,
        quantity INTEGER
      )
    ''');

    // Insert some sample products
    await db.insert('products', {
      'name': 'Laptop', 'description': 'Powerful laptop for work and gaming', 'price': 1200.00, 'imageUrl': 'laptop.jpg'
    });
    await db.insert('products', {
      'name': 'Smartphone', 'description': 'Latest model smartphone with great camera', 'price': 800.00, 'imageUrl': 'smartphone.jpg'
    });
    await db.insert('products', {
      'name': 'Headphones', 'description': 'Noise-cancelling over-ear headphones', 'price': 150.00, 'imageUrl': 'headphones.jpg'
    });
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    Database db = await instance.database;
    return await db.query('products');
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    Database db = await instance.database;
    return await db.query('cart');
  }

  Future<int> addProductToCart(Map<String, dynamic> product) async {
    Database db = await instance.database;
    // Check if product already in cart
    List<Map<String, dynamic>> existingItems = await db.query(
      'cart',
      where: 'productId = ?',
      whereArgs: [product['id']],
    );

    if (existingItems.isNotEmpty) {
      int currentQuantity = existingItems.first['quantity'];
      return await db.update(
        'cart',
        {'quantity': currentQuantity + 1},
        where: 'productId = ?',
        whereArgs: [product['id']],
      );
    } else {
      return await db.insert('cart', {
        'productId': product['id'],
        'name': product['name'],
        'price': product['price'],
        'quantity': 1,
      });
    }
  }

  Future<int> removeProductFromCart(int id) async {
    Database db = await instance.database;
    return await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> clearCart() async {
    Database db = await instance.database;
    return await db.delete('cart');
  }
}
