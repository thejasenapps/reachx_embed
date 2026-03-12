import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class CustomSecondaryTextWidget extends StatelessWidget {
  final String text;
  final IconData icon;

  const CustomSecondaryTextWidget({
    super.key,
    required this.text,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: HexColor(lightBlue),
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 14,
              color: HexColor(secondaryTextColor)
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ],
    );
  }
}
