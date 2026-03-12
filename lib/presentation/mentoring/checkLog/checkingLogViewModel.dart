import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/enums.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/domain/checkLog/checkLogUsecase.dart';
import 'package:get/get.dart';

class CheckingLogViewModel {
  // Method to check the user's login status and navigate accordingly.
  Future<void> checkUserStatus(BuildContext context) async {
    bool result = await CheckLogUsecase().getLog("loggedIn");
    if(result) {
      if (!context.mounted) return;  // Ensures context is still mounted before navigation.
      Get.offNamed(
        "/ExpertRegistration",
        id: NavIds.home,
      );
    } else {
      if (!context.mounted) return;  // Ensures context is still mounted before navigation.
      Get.toNamed(
          '/SignUpScreen',
        arguments: {
            "type": AuthenticationType.login
        },
      );
    }
  }
}
