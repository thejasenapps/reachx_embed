import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class CustomTextFieldWidget extends StatelessWidget {

  final String hintText;
  final TextEditingController textEditingController;

  const CustomTextFieldWidget({super.key, required this.hintText, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
          hintText: hintText,
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
