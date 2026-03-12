import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class CustomCard extends StatelessWidget {
  final Widget content;
  const CustomCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200]!,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: HexColor(containerBorderColor)
          )
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: content,
        ),
      ),
    );
  }
}
