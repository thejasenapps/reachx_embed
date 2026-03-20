import 'package:flutter/material.dart';

class BackNavigationWidget extends StatelessWidget {
  final BuildContext context;

  const BackNavigationWidget({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(this.context),
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 18,
      ),
    );
  }
}
