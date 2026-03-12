import 'package:flutter/material.dart';
import 'package:reachx_embed/core/global_passion.dart';

void showAppSnackBar(
  String message, {
  Color backgroundColor = Colors.grey,
  Duration duration = const Duration(seconds: 3),
}) {
  scaffoldMessengerKey.currentState
    ?..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
}
