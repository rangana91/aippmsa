import 'package:aippmsa/Services/ApiServices.dart';
import 'package:aippmsa/helpers/database_helper.dart';
import 'package:aippmsa/models/Item.dart';
import 'package:sqflite/sqflite.dart';

class ItemService{

  Future<void> updateItemList() async {
    final apiService = ApiServices();
    final itemList = await apiService.fetchItems();

    // Convert the fetched items to Item objects
    List<Item> items = itemList.map<Item>((item) {
      final category = item['category'];
      //remove on server
      String updatedText = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTPNViadqRr2TUSAJKhblKIwIgtO7dIkZcyY2WQWdRoIXmN5Nr-hZwbM4o56PDRGJwJ7c&usqp=CAU';
      return Item(
        id: item['id'],
        name: item['name'],
        description: item['description'],
        image: updatedText,
        price: (item['price'] as num).toDouble(), // Ensure price is converted to double
        categoryName: category['name'],
        categoryDisplayName: category['display_name'],
      );
    }).toList();

    // Use DatabaseHelper to handle the upsert logic
    final databaseHelper = DatabaseHelper();
    await ItemService().upsertItems(items);
  }

  Future<List<Item>> getItemsByCategory(String categoryName) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'category_name = ?',
      whereArgs: [categoryName],
    );

    return List.generate(maps.length, (i) {
      return Item(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        image: maps[i]['image'],
        price: maps[i]['price'],
        categoryName: maps[i]['category_name'],
        categoryDisplayName: maps[i]['category_display_name'],
      );
    });
  }

  Future<void> upsertItems(List<Item> items) async {
    final db = await DatabaseHelper().database;

    for (var item in items) {
      await db.insert(
        'items',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, // Replace if exists
      );
    }
  }

  Future<List<Item>> getItems() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('items');

    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }

}