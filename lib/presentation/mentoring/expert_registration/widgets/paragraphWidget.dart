import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class ParagraphWidget extends StatelessWidget {
  TextEditingController controller;
  String label;
  String? value;
  FocusNode focusNode;

  ParagraphWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.focusNode,
    this.value
  });

  @override
  Widget build(BuildContext context) {

    if(label != value) {
      controller.text = value!;
    }

    return TextField(
      controller: controller,
      maxLines: null,
      focusNode: focusNode,
      // keyboardType: TextInputType.multiline,
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
          )
      ),
    );
  }
}
