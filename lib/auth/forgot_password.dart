import 'package:aippmsa/components/full_width_button.dart';
import 'package:aippmsa/components/input_field.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hides the default back button
        leading: const BackButton(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 24.0), // Spacing before the form
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: FloatingLabelInput(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10), // Adjust the spacing as needed
                const Text(
                  'Please enter your email address. If it matches an account in our system, we will send you a link to reset your password',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Inter'),
                )
              ],
            ),
          ),
          FullWidthButton(
            text: 'Reset Password',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Handle forgot password logic here
              }
            },
            backgroundColor: const Color(0xFF9775FA),
            paddingVertical: 16.0,
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ],
      ),
    );
  }
}
