import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

void showRedSnackBar(String label, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red[400],
        content: Text(
            label,
          style: TextStyle(
            color: HexColor(black)
          ),
        )
    )
  );
}
