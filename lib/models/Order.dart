class Order {
  final int id;
  final int orderNumber;
  final int itemCount;
  final String status;

  Order({
    required this.id,
    required this.orderNumber,
    required this.itemCount,
    required this.status,
  });

  // Create from Map (response from API)
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      orderNumber: map['id'], // Adjust based on your API field names
      itemCount: map['item_count'],     // Directly from API response
      status: map['status'],
    );
  }

  // Convert to Map for local DB insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderNumber,
      'item_count': itemCount,
      'status': status,
    };
  }
}
