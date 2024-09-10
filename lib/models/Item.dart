import 'ItemVariant.dart';  // Make sure to import the ItemVariant class

class Item {
  final int id;
  final String name;
  final String description;
  final String image;
  final double price;
  final String categoryName;
  final String categoryDisplayName;
  List<ItemVariant> variants = [];  // Add a field to store item variants

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.categoryName,
    required this.categoryDisplayName,
    this.variants = const [],  // Initialize with an empty list by default
  });

  // Convert Item to a Map to store in the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'category_name': categoryName,
      'category_display_name': categoryDisplayName,
      // You won't store variants here directly; you'll store them separately
    };
  }

  // Create an Item from a Map (retrieving from the database)
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      image: map['image'],
      price: map['price'],
      categoryName: map['category_name'],
      categoryDisplayName: map['category_display_name'],
      variants: [], // Initialize an empty variant list (you'll populate this later)
    );
  }

  // Method to assign variants to the item
  void setVariants(List<ItemVariant> itemVariants) {
    variants = itemVariants;
  }
}
