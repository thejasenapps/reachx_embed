import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class ConfirmationBoxWidget extends StatelessWidget {
  final VoidCallback functionality;
  final String label;
  const ConfirmationBoxWidget({super.key, required this.functionality, required this.label});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 40,
        children: [
          Text(
            label,
            style: TextStyle(
                color: HexColor(black),
                fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: functionality,
                child: Text(
                  "Yes",
                  style: TextStyle(
                      color: HexColor(lightBlue)
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  "No",
                  style: TextStyle(
                      color: HexColor(lightBlue)
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
