class Order {
  final int id;
  final String orderNumber;
  final int itemCount;
  final String status;
  final String shippingAddress;

  Order({
    required this.id,
    required this.orderNumber,
    required this.itemCount,
    required this.status,
    required this.shippingAddress,
  });

  // Create from Map (response from API)
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      orderNumber: map['order_id'], // Adjust based on your API field names
      itemCount: map['items_count'],     // Directly from API response
      status: map['status_name'],
      shippingAddress: map['shipping_address']
    );
  }

  // Convert to Map for local DB insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderNumber,
      'items_count': itemCount,
      'status_name': status,
      'shipping_address': shippingAddress
    };
  }
}
