import 'package:aippmsa/Services/order_service.dart';
import 'package:aippmsa/models/order.dart';
import 'package:flutter/material.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({super.key});

  @override
  OrdersListState createState() => OrdersListState();
}

class OrdersListState extends State<OrdersList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Order> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this); // 6 Tabs for different statuses
    _loadOrders(); // Load the orders when the screen initializes
  }

  // Method to load orders from the local DB
  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final orders = await OrderService().fetchOrdersFromLocalDb();
      setState(() {
        _orders = orders;
      });
    } catch (e) {
      print('Error loading orders: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Refresh orders by fetching from API and updating local DB
  Future<void> _refreshOrders() async {
    try {
      await OrderService().fetchAndSaveOrders(); // Fetch from API and save to local DB
      await _loadOrders(); // Reload from the local DB
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to refresh orders')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Orders', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // TabBar for filtering orders
          Container(
            padding: const EdgeInsets.fromLTRB(0, 2, 5, 2),
            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(20),
              ),
              tabs: List.generate(_tabController.length, (index) {
                return Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _tabController.index == index ? Colors.purple : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.purple, width: 1),
                    ),
                    child: Text(
                      _tabLabel(index),
                      style: TextStyle(
                        color: _tabController.index == index ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }),
              onTap: (index) {
                setState(() {
                  _tabController.index = index; // Refresh UI to apply changes
                });
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshOrders, // Pull-to-refresh
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                controller: _tabController,
                children: [
                  _buildOrderList(_filterOrdersByStatus('pending')),
                  _buildOrderList(_filterOrdersByStatus('confirmed')),
                  _buildOrderList(_filterOrdersByStatus('processing')),
                  _buildOrderList(_filterOrdersByStatus('completed')),
                  _buildOrderList(_filterOrdersByStatus('cancelled')),
                  _buildOrderList(_filterOrdersByStatus('refunded')), // Example of additional status
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to filter orders based on their status
  List<Order> _filterOrdersByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }

  // Label for each tab
  String _tabLabel(int index) {
    switch (index) {
      case 0:
        return 'Pending';
      case 1:
        return 'Confirmed';
      case 2:
        return 'Processing';
      case 3:
        return 'Completed';
      case 4:
        return 'Cancelled';
      case 5:
        return 'Refunded'; // Example of an additional tab
      default:
        return '';
    }
  }

  // Build the order list based on the filtered data
  Widget _buildOrderList(List<Order> orders) {
    if (orders.isEmpty) {
      // Show "No Orders" message if the list is empty
      return _buildNoOrdersWidget();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index]; // Get the order from the list
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: const Icon(Icons.receipt, color: Colors.black),
            title: Text('Order #${order.orderNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${order.itemCount} items'), // Show the item count
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
            onTap: () {
              // Handle order details navigation here
            },
          ),
        );
      },
    );
  }

  // Widget to show when there are no orders
  Widget _buildNoOrdersWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/orders.png', // Path to your "No Orders" image
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 20),
          const Text(
            'No Orders under this status yet',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
