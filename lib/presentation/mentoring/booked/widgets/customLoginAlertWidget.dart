import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/enums.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/global_variables.dart';
import 'package:reachx_embed/core/navigation/navigationController.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customElevatedButton.dart';

class CustomLoginAlertWidget extends StatelessWidget {
  const CustomLoginAlertWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          spacing: 40,
          children: [
            const Text(
              "Login to see your upcoming bookings",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold
              ),
            ),
            CustomElevatedButton(
                label: "Login",
                onTap: () {
                  NavigationController.to.changePage(NavIds.bookings);
                  checkpoint = "profile";
                  Get.toNamed(
                    '/SignUpScreen',
                    arguments: {
                      "type": AuthenticationType.login
                    },
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}
