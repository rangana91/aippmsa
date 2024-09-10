class ItemVariant {
  final int itemId;
  final String size;
  final String color;
  final int quantity;

  ItemVariant({
    required this.itemId,
    required this.size,
    required this.color,
    required this.quantity,
  });

  // Convert a variant into a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'item_id': itemId,
      'size': size,
      'color': color,
      'quantity': quantity,
    };
  }

  // Create an ItemVariant from a Map (retrieving from database)
  factory ItemVariant.fromMap(Map<String, dynamic> map) {
    return ItemVariant(
      itemId: map['item_id'],
      size: map['size'],
      color: map['color'],
      quantity: map['quantity'],
    );
  }
}
