import 'package:aippmsa/Services/ApiServices.dart';
import 'package:aippmsa/helpers/database_helper.dart';
import 'package:aippmsa/models/Item.dart';
import 'package:aippmsa/models/ItemVariant.dart';
import 'package:sqflite/sqflite.dart';

class ItemService {

  Future<void> updateItemList() async {
    final apiService = ApiServices();
    final itemList = await apiService.fetchItems();

    // Convert the fetched items to Item objects
    List<Item> items = itemList.map<Item>((item) {
      final category = item['category'];
      String updatedText = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTPNViadqRr2TUSAJKhblKIwIgtO7dIkZcyY2WQWdRoIXmN5Nr-hZwbM4o56PDRGJwJ7c&usqp=CAU';

      return Item(
        id: item['id'],
        name: item['name'],
        description: item['description'],
        image: updatedText,
        price: (item['price'] as num).toDouble(),
        categoryName: category['name'],
        categoryDisplayName: category['display_name'],
      );
    }).toList();

    // Use DatabaseHelper to handle the upsert logic
    final databaseHelper = DatabaseHelper();
    await upsertItemsWithVariants(items, itemList); // Updated method to include item variants
  }

  // Fetch all items by category
  Future<List<Item>> getItemsByCategory(String categoryName) async {
    final db = await DatabaseHelper().database;

    // Query the items from the items table
    final List<Map<String, dynamic>> itemMaps = await db.query(
      'items',
      where: 'category_name = ?',
      whereArgs: [categoryName],
    );

    // Generate the Item list with associated variants
    List<Item> items = await Future.wait(itemMaps.map((itemMap) async {
      // Query the variants for each item
      final List<Map<String, dynamic>> variantMaps = await db.query(
        'item_variants',
        where: 'item_id = ?',
        whereArgs: [itemMap['id']],
      );

      // Create the list of variants
      List<ItemVariant> variants = List.generate(variantMaps.length, (i) {
        return ItemVariant(
          itemId: variantMaps[i]['item_id'],
          size: variantMaps[i]['size'],
          color: variantMaps[i]['color'],
          quantity: variantMaps[i]['quantity'],
        );
      });

      // Return the item with its variants
      return Item(
        id: itemMap['id'],
        name: itemMap['name'],
        description: itemMap['description'],
        image: itemMap['image'],
        price: itemMap['price'],
        categoryName: itemMap['category_name'],
        categoryDisplayName: itemMap['category_display_name'],
        variants: variants, // Add the variants to the item
      );
    }).toList());

    return items;
  }


  // Insert or Update (Upsert) items with variants
  Future<void> upsertItemsWithVariants(List<Item> items, List<dynamic> originalItemList) async {
    final db = await DatabaseHelper().database;

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      // Upsert the item
      await db.insert(
        'items',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, // Replace if exists
      );

      // Now handle item variants
      final variants = originalItemList[i]['variants']; // Assuming API provides item variants

      for (var variant in variants) {
        final itemVariant = ItemVariant(
          itemId: item.id,
          size: variant['size'],
          color: variant['color'],
          quantity: variant['quantity'],
        );

        // Check if the variant already exists in the database
        final List<Map<String, dynamic>> existingVariant = await db.query(
          'item_variants',
          where: 'item_id = ? AND size = ? AND color = ?',
          whereArgs: [itemVariant.itemId, itemVariant.size, itemVariant.color],
        );

        if (existingVariant.isNotEmpty) {
          // If the variant exists, update it
          await db.update(
            'item_variants',
            itemVariant.toMap(),
            where: 'item_id = ? AND size = ? AND color = ?',
            whereArgs: [itemVariant.itemId, itemVariant.size, itemVariant.color],
          );
        } else {
          // If the variant does not exist, insert it
          await db.insert(
            'item_variants',
            itemVariant.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    }
  }


  // Fetch all items with their variants
  Future<List<Item>> getItemsWithVariants() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> itemMaps = await db.rawQuery('''
      SELECT i.*, v.size, v.color, v.quantity
      FROM items i
      JOIN item_variants v ON i.id = v.item_id
    ''');

    // Map to Item with variants
    return List.generate(itemMaps.length, (i) {
      final item = Item.fromMap(itemMaps[i]);
      item.variants = [
        ItemVariant(
          itemId: item.id,
          size: itemMaps[i]['size'],
          color: itemMaps[i]['color'],
          quantity: itemMaps[i]['quantity'],
        ),
      ];
      return item;
    });
  }

  // Insert or Update Items
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

  // Get items from the database
  Future<List<Item>> getItems() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('items');

    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }
}
