import 'package:aippmsa/Services/ApiServices.dart';
import 'package:aippmsa/Services/order_service.dart';
import 'package:aippmsa/helpers/database_helper.dart';
import 'package:aippmsa/models/order.dart';
import 'package:sqflite/sqflite.dart';

class OrderService {
  Future<void> fetchAndSaveOrders() async {
    try {
      // Fetch orders from the API
      final apiService = ApiServices();
      final List ordersFromApi = await apiService.fetchOrdersFromApi();
      // Store the orders in the local database
      await clearOrders(); // Clear old orders
      for (var order in ordersFromApi) {
        print(order);
        final parsedOrder = Order.fromMap(order); // Parse the response
        await insertOrder(parsedOrder); // Save in local DB
      }
    } catch (e) {
      // Handle errors, such as showing a Snackbar
      print(e);
      throw Exception('Failed to fetch orders');
    }
  }

  Future<void> insertOrder(Order order) async {
    print('insert order');
    final db = await DatabaseHelper().database;
    await db.insert('orders', order.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Order>> fetchOrdersFromLocalDb() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('orders');
    return List.generate(maps.length, (i) {
      return Order.fromMap(maps[i]);
    });
  }

  Future<void> clearOrders() async {
    final db = await DatabaseHelper().database;
    await db.delete('orders');
  }
}
