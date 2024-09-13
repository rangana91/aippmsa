import 'package:aippmsa/single_product_page.dart';
import 'package:flutter/material.dart';
import 'package:aippmsa/models/Item.dart';

class RecommendedItemsBuilder extends StatelessWidget {
  final Future<List<Item>> futureItems;

  const RecommendedItemsBuilder({required this.futureItems, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Item>>(
      future: futureItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No items found.'));
        } else {
          final items = snapshot.data!;
          return SizedBox(
            height: 250, // Adjust height for the product card
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // This makes the list scroll horizontally
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                const cardWidth = 180.0; // Adjust the card width as needed

                return GestureDetector(
                  onTap: () {
                    // Navigate to the Product Details Page when item is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SingleProductPage(item: item),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: cardWidth,
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
                            height: 150, // Adjust height for image
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                              child: Image.network(
                                item.image, // Assuming the image URL is stored in item.image
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
                                  item.description,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                    color: Color(0xff1D1E20),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Rs. ${item.price}', // Assuming price is a double and needs conversion to string
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
                  ),
                );
              },
            ),
          );
        }
      },
    );

  }
}
