
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class CustomFeeTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final dynamic viewModel;
  final void Function() onSave;

  const CustomFeeTextField({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.hint,
    required this.label,
    required this.viewModel,
    required this.onSave
  });

  @override
  State<CustomFeeTextField> createState() => _CustomFeeTextFieldState();
}

class _CustomFeeTextFieldState extends State<CustomFeeTextField> {

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {

    _focusNode.addListener(() {
      widget.onSave.call();
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
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
                prefixIcon: TextButton(
                  onPressed: () {
                    showCurrencyPicker(
                        context: context,
                        onSelect: (Currency currency) {
                          setState(() {
                            widget.viewModel.currencySymbol = currency.symbol;
                            if(widget.controller.text.isNotEmpty) {
                              widget.onSave.call();
                            }
                          });
                        }
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      Text(
                        widget.viewModel.currencySymbol,
                        style: const TextStyle(
                            color: Colors.black
                        ),
                      )
                    ],
                  ),
                )
            ),
            onFieldSubmitted: (value) {
              if(value.isNotEmpty) {
                widget.onSave.call();
              }
            },
            validator: (value) {
              if(value == null || value.isEmpty) {
                return "Please enter the ${widget.label.toLowerCase()}";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
