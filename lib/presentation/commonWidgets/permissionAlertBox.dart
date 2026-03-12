import 'package:flutter/material.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customElevatedButton.dart';

class PermissionAlertBox extends StatelessWidget {
  const PermissionAlertBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        spacing: 20,
        crossAxisAlignment: .start,
        children: [
          const Text(
            "Shall this journal be posted ?"
          ),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              CustomElevatedButton(
                  label: "Yes",
                  onTap: () {}
              ),
              OutlinedButton(
                  onPressed: () {},
                  child: const Text(
                    "No"
                  )
              )
            ],
          )
        ],
      ),
    );
  }
}
