import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/enums.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/global_variables.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/commonWidgets/backNavigationWidget.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customElevatedButton.dart';
import 'package:reachx_embed/presentation/mentoring/profile/profileViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/signUpScreen.dart';

class EmptyUserWidget extends StatelessWidget {

  final bool isProfile;

  const EmptyUserWidget({super.key, required this.isProfile});

  void _handleLogin(BuildContext context) {
    checkpoint = "homeScreen";
    Navigator.pop(context);

    Future.microtask(() {
      Get.toNamed(
        SignUpScreen.route,
        arguments: {
          "type": AuthenticationType.login,
          "isHomeFlow": true,
        },
        id: NavIds.home
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const SizedBox(height: 20,),
        if(isProfile)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: kIsWeb ? 100 : MediaQuery.of(context).size.width * 0.25,
            children: [
              BackNavigationWidget(context: context),
              Text(
                "My Profile",
                style: TextStyle(
                    color: HexColor(black),
                    fontSize: 16
                ),
              ),
              const SizedBox(width: 40,)
            ],
          ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: .min,
                children: [
                  Image.asset(
                    'lib/assets/images/no-data.png',
                    height: size.height * 0.6,
                    width: size.width * 0.8,
                  ),
                  Text(
                    isProfile ? "You haven't logged in..\nClick the button below to continue" : "You have to login first",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 40,),
                  CustomElevatedButton(
                      label: "Login",
                      onTap: () => _handleLogin(context)
                  )
                ],
              ),
            ),
          )
        ),
      ],
    );
  }
}
