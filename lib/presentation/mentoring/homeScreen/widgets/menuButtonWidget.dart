import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/commonWidgets/confirmationBox.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistration.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/homeScreenViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/profile/profileScreen.dart';

class MenuButtonWidget extends StatefulWidget {
  final HomeScreenViewModel homeScreenViewModel;
  const MenuButtonWidget({
    super.key,
    required this.homeScreenViewModel
  });

  @override
  State<MenuButtonWidget> createState() => _MenuButtonWidgetState();
}

class _MenuButtonWidgetState extends State<MenuButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        color: Colors.white,
        offset: const Offset(40, 40),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Icon(
                Iconsax.settings,
                color: HexColor(lightBlue),
              ),
              // const Text(
              //   'Settings',
              //   style: TextStyle(
              //       fontSize: 11
              //   ),
              // ),
            ],
          ),
        ),
        onSelected: (value) async {
          if(value == 'logout') {
            showDialog(
                context: context,
                builder: (context) {
                  return ConfirmationBoxWidget(
                      label: "Are you sure you want to logout?",
                      functionality: () {
                        Navigator.pop(context);
                        widget.homeScreenViewModel.logOut();
                      }
                  );
                }
            );
          } else if(value == 't&c') {
            final result = await widget.homeScreenViewModel.openUrl('https://www.enapps.in/');

            if(!result) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Unable to open now. Try later"))
              );
            }
          } else if(value == "profile") {
            if(mounted) {
              Get.toNamed(
                ProfileScreen.route,
                id: NavIds.home,
              );
            }
          } else if(value == "profile_edit") {
            if(mounted) {
              Get.toNamed(
                ExpertRegistration.route,
                arguments: {
                  "isRegistration": false,
                },
                id: NavIds.home,
              );
            }
          }  else if(value == "support") {
            widget.homeScreenViewModel.openWhatsApp("support");
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'profile',
            child: Text(
              'Profile',
              style: TextStyle(
                  color: HexColor(lightBlue)
              ),
            ),
          ),
          PopupMenuItem(
            value: 'profile_edit',
            child: Text(
              'Edit Profile',
              style: TextStyle(
                  color: HexColor(lightBlue)
              ),
            ),
          ),
          PopupMenuItem(
            value: 'support',
            child: Text(
              'ReachX Support',
              style: TextStyle(
                  color: HexColor(lightBlue)
              ),
            ),
          ),
          PopupMenuItem(
            value: 't&c',
            child: Text(
              'Terms & Conditions',
              style: TextStyle(
                  color: HexColor(lightBlue)
              ),
            ),
          ),
          PopupMenuItem(
            value: 'logout',
            child: Text(
              'Logout',
              style: TextStyle(
                  color: HexColor(lightBlue)
              ),
            ),
          ),
        ]
    );
  }
}
