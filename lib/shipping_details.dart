import 'package:aippmsa/Services/ApiServices.dart';
import 'package:aippmsa/Services/item_service.dart';
import 'package:aippmsa/Services/payment_service.dart';
import 'package:aippmsa/orders_list.dart';
import 'package:aippmsa/providers/cart_provider.dart'; // Import the CartProvider
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

class ShippingDetails extends StatefulWidget {
  const ShippingDetails({super.key});

  @override
  ShippingDetailsState createState() => ShippingDetailsState();
}

class ShippingDetailsState extends State<ShippingDetails> {
  final PaymentService _paymentService = PaymentService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Create a global key for the form
  final TextEditingController _streetAddressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  bool _isLoading = false;

  Future<void> makePayment(double totalAmount) async {
    try {
      setState(() {
        _isLoading = true; // Show loading
      });
      String? clientSecret = await _paymentService.createPaymentIntent((totalAmount * 100).toInt(), 'lkr');  // Amount in cents

      if (clientSecret != null) {
        await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'Your App Name'
        ));

        await Stripe.instance.presentPaymentSheet();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment successful!')),
          );
          sendCartDataToBackend();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create payment intent.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Hide loading after process completes
        });
      }
    }
  }

  Future<void> sendCartDataToBackend() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cartItems = cartProvider.cartItems;
    String formattedAddress = '${_streetAddressController.text}, '
        '${_stateController.text}, ${_postCodeController.text}, '
        '${_cityController.text}';

    // Prepare the data to be sent
    List<Map<String, dynamic>> cartData = cartItems.map((cartItem) {
      return {
        'item_id': cartItem.item.id,
        'quantity': cartItem.quantity,
        'price': cartItem.item.price,
        'color': cartItem.color,
        'size': cartItem.size
      };
    }).toList();

    // Call the ApiService to send data
    await ApiServices().sendCartDataToBackend(cartData, formattedAddress);
    await ItemService().updateItemList();
    cartProvider.clearCart();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const OrdersList()),
            (Route<dynamic> route) => route.isFirst,
      );

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
        title: const Text(
          'Shipping Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true, // Ensure the content resizes to avoid the keyboard
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction, // Automatically re-validate the form as the user types
            child: Column(
              children: [
                TextFormField(
                  controller: _streetAddressController,
                  decoration: InputDecoration(
                    hintText: 'Street Address',
                    filled: true,
                    fillColor: const Color(0xFFF4F4F4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your street address';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _formKey.currentState?.validate(); // Re-validate when user types
                  },
                ),
                const SizedBox(height: 16.0),

                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    hintText: 'City',
                    filled: true,
                    fillColor: const Color(0xFFF4F4F4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _formKey.currentState?.validate(); // Re-validate when user types
                  },
                ),
                const SizedBox(height: 16.0),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _stateController,
                        decoration: InputDecoration(
                          hintText: 'District',
                          filled: true,
                          fillColor: const Color(0xFFF4F4F4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your district';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _formKey.currentState?.validate(); // Re-validate when user types
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: _postCodeController,
                        decoration: InputDecoration(
                          hintText: 'Post Code',
                          filled: true,
                          fillColor: const Color(0xFFF4F4F4),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your post code';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _formKey.currentState?.validate(); // Re-validate when user types
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    double subtotal = cartProvider.totalPrice;
                    double shippingCost = 8.0;
                    double tax = 0.0;
                    double total = subtotal + shippingCost + tax;

                    return _buildPriceSummary(subtotal, shippingCost, tax, total);
                  },
                ),
                const SizedBox(height: 16.0),

                Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    double subtotal = cartProvider.totalPrice;
                    double shippingCost = 8.0;
                    double total = subtotal + shippingCost;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(134, 102, 225, 100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // If validation passes, proceed to makePayment
                            makePayment(total);
                          }
                        },
                        child: _isLoading
                            ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            : const Text(
                          'Checkout',
                          style: TextStyle(fontSize: 16, color: Color.fromRGBO(255, 255, 255, 100)),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildPriceSummary(double subtotal, double shippingCost, double tax, double total) {
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
}

