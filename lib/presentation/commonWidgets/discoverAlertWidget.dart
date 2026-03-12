import 'package:flutter/material.dart';
import 'package:reachx_embed/core/global_passion.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customElevatedButton.dart';

class DiscoverAlertWidget extends StatelessWidget {
  const DiscoverAlertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 15,
          children: [
            const Text(
                "Oops, you haven't listed your passion.\n\nLet's get started",
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            CustomElevatedButton(
                label: "Tell me how",
                onTap: () {
                  Navigator.pop(context);
                  Get.back();
                  toDiscover.value = !toDiscover.value;
                }
            )
          ],
        ),
      ),
    );
  }
}
