class OrderItem {
  final int id;
  final int orderId;
  final String name;
  final String size;
  final String color;
  final int quantity;
  final double price;
  final String image;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.name,
    required this.size,
    required this.color,
    required this.quantity,
    required this.price,
    required this.image,
  });

  // Convert a Map into an OrderItem
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'],
      orderId: map['order_id'],
      name: map['name'],
      size: map['size'],
      color: map['color'],
      quantity: map['quantity'],
      price: map['price'].toDouble(),
      image: map['item_image'],
    );
  }

  // Convert an OrderItem into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'name': name,
      'size': size,
      'color': color,
      'quantity': quantity,
      'price': price,
      'item_image': image,
    };
  }
}
