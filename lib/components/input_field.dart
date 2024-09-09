import 'package:flutter/material.dart';

class FloatingLabelInput extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? errorText;
  final void Function(String)? onChanged;

  const FloatingLabelInput({
    super.key,
    required this.label,
    this.obscureText = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.errorText,
    this.onChanged,
  });

  @override
  FloatingLabelInputState createState() => FloatingLabelInputState();
}

class FloatingLabelInputState extends State<FloatingLabelInput> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        focusNode: _focusNode,
        validator: widget.validator,
        decoration: InputDecoration(
          labelText: widget.label,
          errorText: widget.errorText,
          labelStyle: TextStyle(
            color: _focusNode.hasFocus ? Colors.blue : Colors.grey,
            fontSize: _focusNode.hasFocus ? 14.0 : 16.0,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          contentPadding: const EdgeInsets.only(bottom: 8.0),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
