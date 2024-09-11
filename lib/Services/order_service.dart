import 'package:aippmsa/Services/ApiServices.dart';
import 'package:aippmsa/Services/order_service.dart';
import 'package:aippmsa/helpers/database_helper.dart';
import 'package:aippmsa/models/OrderItem.dart';
import 'package:aippmsa/models/Order.dart';
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
        print('ORDER $order');
        final List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(order['items']);
        final int orderId = order['id'];
        await OrderService().insertOrderItems(items, orderId);
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
    print('Order TEST: $maps');
    return List.generate(maps.length, (i) {
      return Order.fromMap(maps[i]);
    });
  }

  Future<void> clearOrders() async {
    final db = await DatabaseHelper().database;
    await db.delete('orders');
  }

  // Fetch a single order by its ID
  Future<Order> fetchOrderById(int orderId) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> result = await db.query(
      'orders',
      where: 'id = ?',
      whereArgs: [orderId],
    );

    if (result.isNotEmpty) {
      return Order.fromMap(result.first); // Assuming you have an Order class with fromMap
    } else {
      throw Exception('Order not found');
    }
  }

  // Fetch all items for a specific order
  Future<List<OrderItem>> fetchOrderItemsByOrderId(int orderId) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> result = await db.query(
      'order_items',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );

    print('ORDERID: $result');
    return result.map((item) => OrderItem.fromMap(item)).toList();
  }

  Future<void> insertOrderItems(List<Map<String, dynamic>> items, int orderId) async {
    final db = await DatabaseHelper().database;
    await deleteOrderItemsByOrderId(orderId);
    for (var item in items) {
      await db.insert(
        'order_items',
        {
          'order_id': orderId,
          'name': item['item']['name'],
          'quantity': item['quantity'],
          'price': item['price'],
          'color': item['color'],
          'size': item['size'],
          // 'item_image': item['item']['image'],
          'item_image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTPNViadqRr2TUSAJKhblKIwIgtO7dIkZcyY2WQWdRoIXmN5Nr-hZwbM4o56PDRGJwJ7c&usqp=CAU'
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  //delete given order order items
  Future<void> deleteOrderItemsByOrderId(int orderId) async {
    final db = await DatabaseHelper().database;

    // Delete the order items where the order_id matches the given orderId
    await db.delete(
      'order_items',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );
  }

  // Query the local database to get items by order ID
  Future<List<Map<String, dynamic>>> getItemsByOrderId(String orderId) async {
    final db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> items = await db.query(
      'order_items',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );

    return items;
  }
}
