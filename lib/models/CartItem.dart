import 'package:aippmsa/models/Item.dart';

class CartItem {
  final Item item;
  final String size;
  final String color;
  int quantity;
  final int id;

  CartItem({
    required this.item,
    required this.size,
    required this.color,
    required this.quantity,
    required this.id
  });
}
