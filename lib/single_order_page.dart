import 'package:aippmsa/models/Order.dart';
import 'package:aippmsa/models/OrderItem.dart';
import 'package:flutter/material.dart';
import 'package:aippmsa/Services/order_service.dart';

class SingleOrderPage extends StatefulWidget {
  final int orderId;

  const SingleOrderPage({super.key, required this.orderId});

  @override
  SingleOrderPageState createState() => SingleOrderPageState();
}

class SingleOrderPageState extends State<SingleOrderPage> {
  late Future<Order> _orderDetails;
  late Future<List<OrderItem>> _orderItems;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  void _fetchOrderDetails() {
    _orderDetails = OrderService().fetchOrderById(widget.orderId);
    _orderItems = OrderService().fetchOrderItemsByOrderId(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: FutureBuilder<Order>(
          future: _orderDetails,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                'Order #${snapshot.data!.orderNumber}',
                style: const TextStyle(color: Colors.black),
              );
            } else if (snapshot.hasError) {
              return const Text('Error loading order');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Order>(
        future: _orderDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading order details'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Order not found'));
          }

          final order = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Statuses
                _buildOrderStatus(order.status),
                const SizedBox(height: 16),

                // Order Items Section
                _buildOrderItems(),

                const SizedBox(height: 16),

                // Shipping Details Section
                _buildShippingDetails(order),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderStatus(String status) {
    // Mapping the statuses and their completion states
    List<Map<String, dynamic>> statuses = [
      {"title": "Order Placed", "isCompleted": status == "placed" || status == "confirmed" || status == "shipped" || status == "delivered" || status == 'completed'},
      {"title": "Order Confirmed", "isCompleted": status == "confirmed" || status == "shipped" || status == "delivered" || status == 'completed'},
      {"title": "Shipped", "isCompleted": status == "shipped" || status == "delivered" || status == 'completed'},
      {"title": "Delivered", "isCompleted": status == "delivered" || status == 'completed'},
    ];

    return Column(
      children: statuses.map((item) {
        return _buildStatusTile(item["title"], item["isCompleted"]);
      }).toList(),
    );
  }

  Widget _buildStatusTile(String title, bool isCompleted) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.check_circle,
        color: isCompleted ? Colors.purple : Colors.grey.shade300,
      ),
      title: Text(title)
    );
  }

  Widget _buildOrderItems() {
    return FutureBuilder<List<OrderItem>>(
      future: _orderItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading order items'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Column(
            children: [
              Image.asset('assets/images/empty_cart.png', height: 150), // Use the image you provided
              const Text('No Orders yet', style: TextStyle(fontSize: 18)),
            ],
          );
        }

        final items = snapshot.data!;
        return Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                leading: const Icon(Icons.receipt, color: Colors.black),
                title: Text('${items.length} items'),
                trailing: const Text(
                  'View All',
                  style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Handle the "View All" tap action
                },
              ),
            ),
            const SizedBox(height: 16),
            _buildOrderItemsList(items),
          ],
        );
      },
    );
  }

  Widget _buildOrderItemsList(List<OrderItem> items) {
    return Column(
      children: items.map((item) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: Image.network(item.image, width: 50, height: 50, fit: BoxFit.cover),
            title: Text(item.name),
            subtitle: Text('Size: ${item.size}\nColor: ${item.color}'),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${item.price}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Qty: ${item.quantity}'),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildShippingDetails(Order order) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shipping details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(order.shippingAddress),
            const SizedBox(height: 5)
          ],
        ),
      ),
    );
  }
}
