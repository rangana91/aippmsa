import 'package:aippmsa/Services/ApiServices.dart';
import 'package:aippmsa/Services/item_service.dart';
import 'package:aippmsa/cart_page.dart';
import 'package:aippmsa/components/item_future_builder.dart';
import 'package:aippmsa/components/recommonded_items_builder.dart';
import 'package:aippmsa/models/Item.dart';
import 'package:aippmsa/providers/cart_provider.dart';
import 'package:aippmsa/single_product_page.dart';
import 'package:flutter/material.dart';
import 'package:aippmsa/components/custom_drawer.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;
  bool _isLoading = false;
  late Future<List<Item>> _itemsWomenFuture;
  late Future<List<Item>> _itemsMenFuture;
  late Future<List<Item>> _itemsKidFuture;
  late Future<List<Item>> _itemsRecommended;
  List<Item> _searchResults = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // Define the map of items and their asset paths
  final Map<String, String> items = {
    'Nike': 'assets/nike.png',
    'Adidas': 'assets/adidas.png',
    'Fila': 'assets/fila.png',
    'Lascote': 'assets/lascote.png',
    // Add more items as needed
  };

  // Define a map for the recommended items
  // final List<Map<String, String>> recommendedItems = [
  //   {
  //     'image': 'assets/t_shirt_1.png',
  //     'description': 'Description for item 1',
  //     'price': '\$29.99',
  //   },
  //   {
  //     'image': 'assets/t_shirt_2.png',
  //     'description': 'Description for item 2',
  //     'price': '\$39.99',
  //   },
  //   {
  //     'image': 'assets/t_shirt_3.png',
  //     'description': 'Description for item 3',
  //     'price': '\$39.99',
  //   },
  //   {
  //     'image': 'assets/t_shirt_4.png',
  //     'description': 'Description for item 4',
  //     'price': '\$39.99',
  //   },
    // Add more items as needed
  // ];

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  Future<void> _refreshItems() async {
    await ApiServices().fetchAndSaveUserData();
    setState(() {
      _isLoading = true;
    });

    await ItemService().updateItemList();
    await ItemService().saveRecommendedItems();

    setState(() {
      _isLoading = false;
      _itemsWomenFuture = ItemService().getItemsByCategory('women', 'items');
      _itemsMenFuture = ItemService().getItemsByCategory('men', 'items');
      _itemsKidFuture = ItemService().getItemsByCategory('kids', 'items');
      _itemsRecommended = ItemService().getItemsByCategory('Recommended', 'recommended_items');
    });
  }

  Future<List<Item>> searchItems(String query) async {
    if (query.isEmpty) {
      return [];
    }
    return ItemService().searchItemsByName(query);
  }

  void _toggleDrawer() {
    if (_isDrawerOpen) {
      _scaffoldKey.currentState?.closeDrawer(); // Use closeDrawer to close
    } else {
      _scaffoldKey.currentState?.openDrawer(); // Use openDrawer to open
    }
    setState(() {
      _isDrawerOpen = !_isDrawerOpen; // Update drawer state
    });
  }

  void _onSearchChanged(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        _isSearching = true;
      });
      List<Item> results = await searchItems(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              int cartItemCount = cartProvider.cartItems.length;
              return IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
                icon: Stack(
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.black,
                      size: 24.0,
                    ),
                    if (cartItemCount > 0)
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$cartItemCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
        leading: IconButton(
          icon: Image.asset(
            _isDrawerOpen ? 'assets/hamburger.png' : 'assets/hamburger.png',
            color: Colors.black,
            width: 20,
            height: 20,
          ),
          onPressed: _toggleDrawer,
        ),
      ),
      drawer: CustomDrawer(
        isOpen: _isDrawerOpen,
        onToggleDrawer: _toggleDrawer,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshItems,
        child: _isLoading
            ? const Center(
          child: CircularProgressIndicator(), // Display loader while loading
        )
            : SingleChildScrollView(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AIPPMSA',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const Text(
                'Hi! Rangana',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: Color(0xff8F959E),
                ),
              ),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffF5F6FA),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          fillColor: const Color(0xffF5F6FA),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10.0),
                          border: InputBorder.none,
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        onChanged: (query) {
                          _onSearchChanged(query);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.blue,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _isSearching
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : _searchResults.isNotEmpty
                  ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final item = _searchResults[index];
                  return ListTile(
                    title: Text(item.name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SingleProductPage(item: item),
                        ),
                      );
                    },
                  );
                },
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Recommended For You',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                      color: Color(0xff1D1E20),
                    ),
                  ),
                  const SizedBox(height: 20),
                  RecommendedItemsBuilder(
                      futureItems: _itemsRecommended),
                  const SizedBox(height: 20),
                  const Text(
                    'For Men',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                      color: Color(0xff1D1E20),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ItemFutureBuilder(
                      futureItems: _itemsMenFuture),
                  const SizedBox(height: 20),
                  const Text(
                    'For Women',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                      color: Color(0xff1D1E20),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ItemFutureBuilder(
                      futureItems: _itemsWomenFuture),
                  const SizedBox(height: 20),
                  const Text(
                    'For Kids',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                      color: Color(0xff1D1E20),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ItemFutureBuilder(
                      futureItems: _itemsKidFuture),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
