import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'aippmsa.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        // Create items table
        await db.execute('''
          CREATE TABLE items (
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            image TEXT,
            price REAL,
            category_name TEXT,
            category_display_name TEXT
          )
        ''');

        // Create recommended items table
        await db.execute('''
          CREATE TABLE recommended_items (
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            image TEXT,
            price REAL,
            category_name TEXT,
            category_display_name TEXT
          )
        ''');

        // Create item_variants table for storing size, color, and quantity
        await db.execute('''
          CREATE TABLE item_variants (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            item_id INTEGER,
            size TEXT,
            color TEXT,
            quantity INTEGER,
            FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE
          )
        ''');

        //create orders table
        await db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY,
            order_id STRING,
            items_count INTEGER,
            status_name TEXT,
            shipping_address TEXT
          )
        ''');

        //create order items table
        await db.execute('''
          CREATE TABLE order_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            order_id INTEGER,
            name TEXT,
            quantity INTEGER,
            price REAL,
            color TEXT,
            size TEXT,
            item_image TEXT
          )
        ''');

        //create user table
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            first_name TEXT,
            last_name TEXT,
            date_of_birth TEXT,
            gender TEXT,
            email TEXT,
            address TEXT,
            number TEXT,
            city TEXT,
            post_code TEXT
          )
        ''');
      },
    );
  }

  // Insert item into the database
  Future<int> insertItem(Map<String, dynamic> item) async {
    final db = await database;
    return await db.insert('items', item);
  }

  // Insert item variant into the database
  Future<int> insertItemVariant(Map<String, dynamic> variant) async {
    final db = await database;
    return await db.insert('item_variants', variant);
  }

  // Fetch all items with variants
  Future<List<Map<String, dynamic>>> getItemsWithVariants() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT i.*, v.size, v.color, v.quantity
      FROM items i
      JOIN item_variants v ON i.id = v.item_id
    ''');
  }

  // Update item and variant
  Future<int> updateItem(Map<String, dynamic> item) async {
    final db = await database;
    return await db.update('items', item, where: 'id = ?', whereArgs: [item['id']]);
  }

  Future<int> updateItemVariant(Map<String, dynamic> variant) async {
    final db = await database;
    return await db.update('item_variants', variant, where: 'id = ?', whereArgs: [variant['id']]);
  }

  // Delete item and its variants
  Future<int> deleteItem(int itemId) async {
    final db = await database;
    return await db.delete('items', where: 'id = ?', whereArgs: [itemId]);
  }
}
