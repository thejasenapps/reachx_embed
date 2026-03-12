import 'package:flutter/material.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';

class CustomNetworkAlert extends StatelessWidget {
  const CustomNetworkAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Iconsax.danger,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text("No Internet access", style: TextStyle(fontSize: 18)),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("close")
          )
        ],
      ),
    );
  }
}
