import 'package:aippmsa/shipping_details.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  // Initialize variables for quantities and prices
  int _quantity1 = 1;
  int _quantity2 = 1;
  double _price1 = 148.0;
  double _price2 = 52.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Remove all action
            },
            child: const Text(
              'Remove All',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCartItem(
              imageUrl: 'https://via.placeholder.com/100', // Replace with actual image URL
              itemName: "Men's Harrington Jacket",
              size: 'M',
              color: 'Lemon',
              price: _price1,
              quantity: _quantity1,
              onQuantityChanged: (newQuantity) {
                setState(() {
                  _quantity1 = newQuantity;
                });
              },
            ),
            _buildCartItem(
              imageUrl: 'https://via.placeholder.com/100', // Replace with actual image URL
              itemName: "Men's Coaches Jacket",
              size: 'M',
              color: 'Black',
              price: _price2,
              quantity: _quantity2,
              onQuantityChanged: (newQuantity) {
                setState(() {
                  _quantity2 = newQuantity;
                });
              },
            ),
            const SizedBox(height: 16.0),
            _buildPriceSummary(),
            const SizedBox(height: 16.0),
            _buildCouponInput(),
            const SizedBox(height: 16.0),
            _buildCheckoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem({
    required String imageUrl,
    required String itemName,
    required String size,
    required String color,
    required double price,
    required int quantity,
    required Function(int) onQuantityChanged,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Image of the item
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Size - $size',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Color - $color',
                          style: const TextStyle(fontSize: 14, color: Colors.purple),
                        ),
                      ),
                    ],
                  )

                ],
              ),
            ),
            const SizedBox(width: 10),
            // Quantity Controls and Price
            Column(
              children: [
                Row(
                  children: [
                    // Decrement Button
                    _buildQuantityButton(Icons.remove, () {
                      if (quantity > 1) {
                        onQuantityChanged(quantity - 1);
                      }
                    }),
                    const SizedBox(width: 5),
                    Text(
                      '$quantity',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    _buildQuantityButton(Icons.add, () {
                      onQuantityChanged(quantity + 1);
                    }),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '\$$price',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, Function onPressed) {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        color: Colors.purple,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        iconSize: 16,
        onPressed: () => onPressed(),
      ),
    );
  }

  Widget _buildPriceSummary() {
    double subtotal = (_quantity1 * _price1) + (_quantity2 * _price2);
    double shippingCost = 8.0;
    double tax = 0.0;
    double total = subtotal + shippingCost + tax;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPriceRow('Subtotal', subtotal),
        _buildPriceRow('Shipping Cost', shippingCost),
        _buildPriceRow('Tax', tax),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              '\$$total',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(
          '\$$value',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildCouponInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer, color: Colors.green),
          const SizedBox(width: 10),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter Coupon Code',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.purple),
            onPressed: () {
              // Handle coupon code submission
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          backgroundColor: const Color.fromRGBO(134, 102, 225, 100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ShippingDetails()),
          );
        },
        child: const Text(
          'Proceed',
          style: TextStyle(fontSize: 16.0, color: Color.fromRGBO(255, 255, 255, 100)),
        ),
      ),
    );
  }
}
