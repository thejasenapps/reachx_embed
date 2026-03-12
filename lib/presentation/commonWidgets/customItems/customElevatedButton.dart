import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class CustomElevatedButton extends StatelessWidget {

  final String label;
  final VoidCallback onTap;
  final bool? special;

  const CustomElevatedButton({super.key, required this.label, required this.onTap, this.special});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
           RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(30),
           )
          ),
          maximumSize: WidgetStateProperty.all<Size>(
           const Size(250, 40),
          ),
          minimumSize: WidgetStateProperty.all(
            const Size(120, 40)
          ),
          backgroundColor: WidgetStateProperty.all(
            special != null && special! ? HexColor(specialColor) : HexColor(buttonColor)
          ),
        ),
        child: Text(
            label,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w900
          ),
        )
    );
  }
}
