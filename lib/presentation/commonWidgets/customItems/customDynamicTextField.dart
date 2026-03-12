import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class CustomDynamicTextFieldWidget extends StatelessWidget {

  final String hintText;
  final int? maxLength;
  final TextEditingController textEditingController;

  const CustomDynamicTextFieldWidget({super.key, required this.hintText, required this.textEditingController, required this.maxLength});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      minLines: 1,
      maxLines: 5,
      maxLength: maxLength,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
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
          ),
          counterText: ''
      ),
    );
  }
}
