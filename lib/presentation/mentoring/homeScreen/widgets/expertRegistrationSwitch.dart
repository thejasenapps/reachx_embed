import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/homeScreen.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/homeScreenViewModel.dart';


class ExpertRegistrationSwitchWidget extends StatefulWidget {

  HomeScreenViewModel homeScreenViewModel;
  bool isExpert;
  bool isTopicList;

  ExpertRegistrationSwitchWidget({super.key, required this.homeScreenViewModel, required this.isExpert, required this.isTopicList});

  @override
  State<ExpertRegistrationSwitchWidget> createState() => _ExpertRegistrationSwitchWidgetState();
}

class _ExpertRegistrationSwitchWidgetState extends State<ExpertRegistrationSwitchWidget> {
  @override
  Widget build(BuildContext context) {

    return Center(
        child: GestureDetector(
          onTap: () {
            widget.homeScreenViewModel.isLogged(context);
          },
          child: Container(
            decoration: BoxDecoration(
                color: HexColor(specialColor),
                borderRadius: BorderRadius.circular(20)
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: const Text(
              "Book a Mentor",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12
              ),
            ),
          ),
        )
    );
  }
}
