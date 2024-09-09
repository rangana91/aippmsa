import 'package:aippmsa/components/custom_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:aippmsa/models/Item.dart';

class SingleProductPage extends StatefulWidget {
  final Item item;

  const SingleProductPage({required this.item, super.key});

  @override
  SingleProductPageState createState() => SingleProductPageState();
}

class SingleProductPageState extends State<SingleProductPage> {
  int _quantity = 1;

  String? _selectedSizeOption;
  String? _selectedColorOption;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Image.network(
              widget.item.image,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),

            // Product Title and Price
            Text(
              widget.item.name,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "\$${widget.item.price}",
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            CustomDropdown(
              label: 'Size',
              title: 'Select a Size',
              selectedOption: _selectedSizeOption, // This is a state variable
              options: const ['S', 'M', 'L', 'XL'], // List of options
              onOptionSelected: (selected) {
                setState(() {
                  _selectedSizeOption = selected; // Handle the selected option
                });
              },
            ),
            const SizedBox(height: 20),
            CustomDropdown(
              label: 'Color',
              title: 'Select a Color',
              selectedOption: _selectedColorOption, // This is a state variable
              options: const ['Orange', 'Black', 'Green', 'White'], // List of options
              onOptionSelected: (selected) {
                setState(() {
                  _selectedColorOption = selected; // Handle the selected option
                });
              },
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Text(
                    'Quantity',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.3),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      iconSize: 16,
                      icon: const Icon(Icons.remove, color: Colors.white),
                      onPressed: _decrementQuantity,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),

                  const SizedBox(width: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      '$_quantity',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      iconSize: 16,
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: _incrementQuantity,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Product Description
            Text(
              widget.item.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      // Bottom Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.5, 5.0),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(134, 102, 225, 100),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${widget.item.price}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(255, 255, 255, 100)
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle Add to Cart
                },
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(255, 255, 255, 100)
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
