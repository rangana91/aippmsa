import 'package:flutter/material.dart';

class BackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final double padding;

  const BackButton({
    super.key,
    this.onPressed,
    this.backgroundColor = const Color(0xFFF5F6FA),
    this.iconColor = Colors.black,
    this.padding = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding), // Adjustable padding
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6FA), // Background color of the button
          shape: BoxShape.circle, // Circular shape for the button
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: iconColor), // Icon color
          onPressed: onPressed ?? () => Navigator.pop(context), // Default action is to go back
        ),
      ),
    );
  }
}
