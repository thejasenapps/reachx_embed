import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class CustomParagraphTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final dynamic viewModel;
  final void Function()? onSubmission;

  const CustomParagraphTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.viewModel,
    required this.onSubmission
  });

  @override
  State<CustomParagraphTextField> createState() => _CustomParagraphTextFieldState();
}

class _CustomParagraphTextFieldState extends State<CustomParagraphTextField> {

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.addListener(() {
      widget.onSubmission!.call();
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      maxLines: null,
      onTapOutside: (_)=> FocusScope.of(context).unfocus(),
      // keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
              color: HexColor(secondaryTextColor)
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none
      ),
      onSubmitted: (value) {
        if(value.isNotEmpty) {
          widget.onSubmission!.call();
        }
      },
    );
  }
}
