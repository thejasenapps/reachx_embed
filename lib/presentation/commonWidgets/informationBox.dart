import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class InformationBoxWidget extends StatelessWidget {
  final String label;
  bool? isExpert;

  InformationBoxWidget({super.key, required this.label, this.isExpert});

  @override
  Widget build(BuildContext context) {

    isExpert ??= false;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      backgroundColor: Colors.white,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            const SizedBox(height: 5,),
            Text(
              label,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            Visibility(
              visible: isExpert!,
              child: const Text(
                '*If there is any pending meetings, the account will not be deleted',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              spacing: 30,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    "Proceed",
                    style: TextStyle(
                        color: HexColor(lightBlue)
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: HexColor(lightBlue)
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
