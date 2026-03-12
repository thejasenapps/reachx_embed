import 'package:flutter/material.dart';

class CustomSnackBar {

  void customAlertSnackBar(BuildContext context, String text, int seconds, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            duration: Duration(seconds: seconds),
            backgroundColor: color,
            content: Text(
                text,
              style: const TextStyle(
                color: Colors.white
              ),
            )
        )
    );
  }
}