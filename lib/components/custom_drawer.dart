import 'package:aippmsa/Services/order_service.dart';
import 'package:aippmsa/Services/user_service.dart';
import 'package:aippmsa/cart_page.dart';
import 'package:aippmsa/main.dart';
import 'package:aippmsa/models/Order.dart';
import 'package:aippmsa/models/User.dart';
import 'package:aippmsa/orders_list.dart';
import 'package:aippmsa/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomDrawer extends StatefulWidget {
  final bool isOpen;
  final Function onToggleDrawer;

  const CustomDrawer({
    required this.isOpen,
    required this.onToggleDrawer,
    super.key,
  });

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  User? _user;
  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadOrders();
  }

  Future<void> _loadUser() async {
    final user = await UserService().getUser();
    setState(() {
      _user = user;
    });
  }

  Future<void> _loadOrders() async {
    final orders = await OrderService().fetchOrdersFromLocalDb();
    setState(() {
      _orders = orders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Tap outside the drawer to close it
        if (widget.isOpen)
          GestureDetector(
            onTap: () {
              widget.onToggleDrawer();
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
        // Drawer itself
        Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildProfileHeader(), // Custom header design
              const SizedBox(height: 10),
              _buildDrawerItem(Icons.person_outline, "Account Information", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
              }),
              _buildDrawerItem(Icons.shopping_bag_outlined, "Cart", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              }),
              _buildDrawerItem(Icons.list, "Orders", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrdersList()),
                );
              }),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  _logout();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build drawer header with user profile
  Widget _buildProfileHeader() {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      currentAccountPicture: const CircleAvatar(
        backgroundImage: NetworkImage(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTPNViadqRr2TUSAJKhblKIwIgtO7dIkZcyY2WQWdRoIXmN5Nr-hZwbM4o56PDRGJwJ7c&usqp=CAU',
        ),
      ),
      accountName: _user != null
          ? Text(
        _user!.firstName ?? 'Guest',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      )
          : const Text(
        'Loading...',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      accountEmail: const Row(
        children: [
          Text(
            'Verified Profile',
            style: TextStyle(color: Colors.green),
          ),
          SizedBox(width: 5),
          Icon(Icons.verified, color: Colors.green, size: 16),
        ],
      ),
      otherAccountsPictures: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _orders.length.toString(),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to create drawer items
  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Future<void> _logout() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'authToken');

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Flutter Demo Home Page')),
      );
    }
  }
}
