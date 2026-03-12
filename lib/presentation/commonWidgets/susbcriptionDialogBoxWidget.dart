import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customElevatedButton.dart';

class SubscriptionDialogBoxWidget extends StatelessWidget {
  final String description;
  final VoidCallback execute;

  const SubscriptionDialogBoxWidget({
    super.key,
    required this.description,
    required this.execute
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () => Navigator.pop(context, false),
          child: const Icon(
            Icons.cancel_rounded,
            size: 20,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: .center,
          spacing: 20,
          children: [
            Text(
              description,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: HexColor(lightBlue)
              ),
              textAlign: TextAlign.center,
            ),
            Lottie.asset(
              'lib/assets/lottie/upgrade_rocket.json',
              height: 200
            ),
            CustomElevatedButton(
                label: "I'm Interested",
                onTap: execute
            )
          ],
        ),
      ),
    );
  }
}
