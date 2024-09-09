import 'package:flutter/material.dart';

class ShowModal {
  void showErrorDialog(String message, BuildContext context, onPressedOk) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: onPressedOk,
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog(String message, BuildContext context, onPressedOk) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Successful'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: onPressedOk,
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}