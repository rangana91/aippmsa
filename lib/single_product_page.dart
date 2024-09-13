import 'package:aippmsa/components/custom_drop_down.dart';
import 'package:aippmsa/models/CartItem.dart';
import 'package:aippmsa/models/Item.dart';
import 'package:aippmsa/models/ItemVariant.dart';
import 'package:aippmsa/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  // Increase the quantity of the product
  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  // Decrease the quantity of the product
  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  // Show a SnackBar for alerts (feedback)
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
            // Display the product image
            Image.network(
              widget.item.image,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),

            // Display product name and price
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

            // Size selection dropdown
            CustomDropdown(
              label: 'Size',
              title: 'Select a Size',
              selectedOption: _selectedSizeOption,
              options: widget.item.variants.map((variant) => variant.size).toSet().toList(),
              onOptionSelected: (selected) {
                setState(() {
                  _selectedSizeOption = selected;
                  _selectedColorOption = null; // Reset color option when size changes
                });
              },
            ),
            const SizedBox(height: 20),

            // Color selection dropdown
            _selectedSizeOption == null
                ? Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: const Text(
                'Please select a size first',
                style: TextStyle(fontSize: 16),
              ),
            )
                : CustomDropdown(
              label: 'Color',
              title: 'Select a Color',
              selectedOption: _selectedColorOption,
              options: widget.item.variants
                  .where((variant) => variant.size == _selectedSizeOption)
                  .map((variant) => variant.color)
                  .toSet()
                  .toList(),
              onOptionSelected: (selected) {
                setState(() {
                  _selectedColorOption = selected;
                });
              },
            ),

            const SizedBox(height: 20),

            // Quantity selector
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Text('Quantity', style: TextStyle(fontSize: 16)),
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
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text('$_quantity', style: const TextStyle(fontSize: 16)),
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
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Product description
            Text(widget.item.description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 20),
          ],
        ),
      ),

      // Add to Cart button at the bottom
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            if (_selectedSizeOption != null && _selectedColorOption != null) {
              // Try to find the item with the selected size and color
              ItemVariant? selectedVariant;
              try {
                selectedVariant = widget.item.variants.firstWhere(
                      (variant) =>
                  variant.size == _selectedSizeOption && variant.color == _selectedColorOption,
                );
              } catch (e) {
                selectedVariant = null;  // Set to null if no matching variant is found
              }

              if (selectedVariant != null) {
                if (_quantity > selectedVariant.quantity) {
                  _showSnackBar('Stock not available for the selected quantity!');
                } else {
                  // Add the item to the cart
                  Provider.of<CartProvider>(context, listen: false).addItem(
                    CartItem(
                      item: widget.item,
                      size: _selectedSizeOption!,
                      color: _selectedColorOption!,
                      quantity: _quantity,
                      id: widget.item.id,
                    ),
                  );
                  _showSnackBar('Item added to cart!');
                }
              } else {
                _showSnackBar('This size and color combination is not available!');
              }
            } else {
              _showSnackBar('Please select size and color!');
            }

          },
          child: const Text(
              'Add to Cart',
            style: TextStyle(color: Color.fromRGBO(255, 255, 255, 100)),
          ),
        ),
      ),
    );
  }
}
