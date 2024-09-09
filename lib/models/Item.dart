import 'package:aippmsa/Services/ApiServices.dart';
import 'package:aippmsa/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class Item {
  final int id;
  final String name;
  final String description;
  final String image;
  final double price;
  final String categoryName;
  final String categoryDisplayName;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.categoryName,
    required this.categoryDisplayName,
  });

  // Convert an Item into a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'category_name': categoryName,
      'category_display_name': categoryDisplayName,
    };
  }

  // Convert a Map into an Item
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      image: map['image'],
      price: map['price'],
      categoryName: map['category_name'],
      categoryDisplayName: map['category_display_name'],
    );
  }

}
