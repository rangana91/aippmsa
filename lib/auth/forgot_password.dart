import 'dart:math';

import 'package:aippmsa/Services/ApiServices.dart';
import 'package:aippmsa/components/full_width_button.dart';
import 'package:aippmsa/components/input_field.dart';
import 'package:aippmsa/helpers/show_modal.dart';
import 'package:aippmsa/main.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // Loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hides the default back button
        leading: const BackButton(),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      ),
                      const SizedBox(height: 70), // Space above the button
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FullWidthButton(
              text: _isLoading ? '' : 'Reset Password',
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true; // Show loading indicator
                  });

                  try {
                    final apiService = ApiServices();
                    print('test 3 ${_emailController.text}');
                    final response = await apiService.resetPassword(_emailController.text);

                    if (context.mounted) {
                      if (response.status) {
                        ShowModal().showSuccessDialog(response.message!, context, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MyHomePage(title: 'AIPPMSA')),
                          );
                        });
                      } else {
                        ShowModal().showErrorDialog(response.message!, context, () {
                          Navigator.of(context).pop(); // Close the dialog
                        });
                      }
                    }
                  } catch (e) {
                    // Show error message
                    print('test $e');
                    if (context.mounted) {
                      ShowModal().showErrorDialog('Failed to send the reset email. Please try again 1.', context, () {
                        Navigator.of(context).pop(); // Close the dialog
                      });
                    }
                  } finally {
                    setState(() {
                      _isLoading = false; // Hide loading indicator
                    });
                  }
                }
              },
              backgroundColor: const Color(0xFF9775FA),
              paddingVertical: 16.0,
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
