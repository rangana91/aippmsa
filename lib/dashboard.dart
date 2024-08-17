import 'package:aippmsa/components/custom_drawer.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
      if (_isDrawerOpen) {
        _scaffoldKey.currentState?.openDrawer();
      } else {
        Navigator.of(context).pop(); // Close the drawer
      }
    });
  }

  // Define the map of items and their asset paths
  final Map<String, String> items = {
    'Nike': 'assets/nike.png',
    'Adidas': 'assets/adidas.png',
    'Fila': 'assets/fila.png',
    'Lascote': 'assets/lascote.png',
    // Add more items as needed
  };

  // Define a map for the recommended items
  final List<Map<String, String>> recommendedItems = [
    {
      'image': 'assets/t_shirt_1.png',
      'description': 'Description for item 1 test long description',
      'price': '\$29.99',
    },
    {
      'image': 'assets/t_shirt_2.png',
      'description': 'Description for item 2',
      'price': '\$39.99',
    },
    {
      'image': 'assets/t_shirt_3.png',
      'description': 'Description for item 3',
      'price': '\$39.99',
    },
    {
      'image': 'assets/t_shirt_4.png',
      'description': 'Description for item 4',
      'price': '\$39.99',
    },
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: (){},
              icon: const Icon(
                Icons.shopping_bag_outlined, // Replace with your desired icon
                color: Colors.black,
                size: 24.0,
              ),
          )
        ],
        leading: IconButton(
          icon: Image.asset(
            _isDrawerOpen
                ? 'assets/hamburger.png'
                : 'assets/hamburger.png',
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
      body: SingleChildScrollView(
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
            const SizedBox(height: 12.0,),
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
                      decoration: InputDecoration(
                        fillColor: const Color(0xffF5F6FA),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                        border: InputBorder.none,
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
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
                    onPressed: () {
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Most Popular',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 19,
                color: Color(0xff1D1E20),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 70,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: items.entries.map((entry) {
                  return Container(
                    margin: const EdgeInsets.only(right: 18.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xffF5F6FA),
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          margin: const EdgeInsets.only(right: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              entry.value,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Flexible(
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
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
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14.0,
                mainAxisSpacing: 14.0,
                childAspectRatio: 0.65,
              ),
              itemCount: recommendedItems.length,
              itemBuilder: (context, index) {
                final item = recommendedItems[index];
                const cardHeight = 400.0;

                return SizedBox(
                  height: cardHeight,
                  child: Card(
                    color: const Color(0xffF5F6FA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: cardHeight * 0.40,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                            child: Image.asset(
                              item['image']!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['description']!,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  color: Color(0xff1D1E20),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                item['price']!,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xff1D1E20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
