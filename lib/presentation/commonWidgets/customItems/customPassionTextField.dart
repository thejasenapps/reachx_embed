import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class CustomPassionTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final dynamic viewModel;
  final void Function()? onSubmission;

  const CustomPassionTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.keyboardType,
    required this.viewModel,
    required this.onSubmission

  });

  @override
  State<CustomPassionTextField> createState() => _CustomPassionTextFieldState();
}

class _CustomPassionTextFieldState extends State<CustomPassionTextField> {

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {

    _focusNode.addListener(() {
      widget.onSubmission;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 70,
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: widget.keyboardType,
              maxLength: 50,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: HexColor(containerBorderColor),
                    )
                ),
                labelText: widget.label,
                labelStyle: const TextStyle(
                  fontSize: 12,
                ),
                hintText: widget.hint,
                hintStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey
                ),
              ),
              onFieldSubmitted: (value) {
                if(widget.controller.text.isNotEmpty) {
                  widget.onSubmission;
                }
              },
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return "Please enter the ${widget.label.toLowerCase()}";
                }
                return null;
              },
            )
        ),
      ],
    );
  }
}
