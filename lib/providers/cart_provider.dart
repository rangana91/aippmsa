import 'package:aippmsa/models/CartItem.dart';
import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addItem(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void updateQuantity(CartItem item, int newQuantity) {
    if (newQuantity > 0) {
      item.quantity = newQuantity;
    } else {
      removeItem(item);
    }
    notifyListeners();
  }

  int get totalItems => _cartItems.length;

  double get totalPrice {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item.item.price * item.quantity;
    }
    return total;
  }

  bool isStockAvailable() {
    try {
      for (var item in _cartItems) {
        // Attempt to find the variant based on size and color
        final variant = item.item.variants.firstWhere(
              (v) => v.size == item.size && v.color == item.color,
        );

        // If the requested quantity exceeds the available stock, return false
        if (item.quantity > variant.quantity) {
          return false;
        }
      }
      // If all items have valid stock, return true
      return true;
    } catch (e) {
      // If any variant is not found, return false
      return false;
    }
  }

}
