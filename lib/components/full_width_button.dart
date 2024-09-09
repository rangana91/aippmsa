import 'package:flutter/material.dart';

class FullWidthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final double paddingVertical;
  final double fontSize;
  final FontWeight fontWeight;
  final String fontFamily;
  final Widget? child;

  const FullWidthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF9775FA),
    this.paddingVertical = 16.0,
    this.fontSize = 17.0,
    this.fontWeight = FontWeight.bold,
    this.fontFamily = 'Inter',
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: double.infinity, // Full width
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // No rounded edges
            ),
            backgroundColor: backgroundColor, // Button color
            padding: EdgeInsets.symmetric(vertical: paddingVertical),
          ),
          child: child ?? Text(
            text,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: fontSize,
              color: Colors.white,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}
