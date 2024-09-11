import 'package:flutter/material.dart';

class CustomCardInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPassword;

  const CustomCardInputField({
    super.key,
    required this.labelText,
    required this.controller,
    this.validator,
    this.isPassword = false, // Default is not a password field
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: labelText,
          ),
          validator: validator,
        ),
      ),
    );
  }
}
