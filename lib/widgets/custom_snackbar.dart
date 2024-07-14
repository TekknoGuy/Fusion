import 'package:flutter/material.dart';

class CustomSnackBar {
  static SnackBar createSnackBar(String message) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      createSnackBar(message),
    );
  }
}