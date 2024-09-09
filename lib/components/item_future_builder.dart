import 'package:aippmsa/single_product_page.dart';
import 'package:flutter/material.dart';
import 'package:aippmsa/models/Item.dart';

class ItemFutureBuilder extends StatelessWidget {
  final Future<List<Item>> futureItems;

  const ItemFutureBuilder({required this.futureItems, super.key});

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
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14.0,
              mainAxisSpacing: 14.0,
              childAspectRatio: 0.65,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              const cardHeight = 400.0;

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
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                item.price.toString(), // Assuming price is a double and needs conversion to string
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
          );
        }
      },
    );
  }
}
