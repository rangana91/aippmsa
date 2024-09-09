import 'package:aippmsa/Services/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  CheckoutPageState createState() => CheckoutPageState();
}

class CheckoutPageState extends State<CheckoutPage> {
  final PaymentService _paymentService = PaymentService();

  // Method to create payment and confirm it
  Future<void> makePayment() async {
    try {
      // Call the Laravel backend to create a PaymentIntent
      String? clientSecret = await _paymentService.createPaymentIntent(2000, 'usd');  // Amount in cents

      if (clientSecret != null) {
        // Create PaymentMethod and confirm payment
        await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Your App Name'
        ));

        // Present the payment sheet to the user
        await Stripe.instance.presentPaymentSheet();

        // Payment was successful
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment successful!')),
          );
        }
      } else {
        // Handle error if clientSecret is null
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create payment intent.')),
          );
        }
      }
    } catch (e) {
      // Handle any errors during the payment process
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: makePayment,
          child: const Text('Pay Now'),
        ),
      ),
    );
  }
}
