
import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class ImageEditingButton extends StatefulWidget {

  final VoidCallback function;
  final String text;

  const ImageEditingButton({super.key, required this.function,required this.text});

  @override
  State<ImageEditingButton> createState() => _ImageEditingButtonState();
}

class _ImageEditingButtonState extends State<ImageEditingButton> {
  @override
  Widget build(BuildContext context) {
    return  TextButton(
      onPressed: widget.function,
      style: TextButton.styleFrom(
        side:  BorderSide(width: 1, color: HexColor(containerBorderColor)),
        shape: const StadiumBorder()
      ),
      child: Text(
          widget.text,
        style: TextStyle(
          color: HexColor(lightBlue)
        ),
      ),
    );
  }
}
