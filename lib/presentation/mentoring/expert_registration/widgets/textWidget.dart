import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class TextWidget extends StatelessWidget {
  TextEditingController controller;
  FocusNode focusNode;
  String label;

  TextWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(
              color: HexColor(secondaryTextColor)
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: HexColor(containerBorderColor),
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: HexColor(containerBorderColor),
              )
          ),
          contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 15
          )
      ),
    );
  }
}
