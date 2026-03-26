import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/meetingSetupViewModel.dart';

class GuidelinesWidget extends StatelessWidget {
  final MeetingSetupViewModel meetingSetupViewModel;

  const GuidelinesWidget({
    super.key,
    required this.meetingSetupViewModel
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        spacing: 5,
        children: meetingSetupViewModel.guidelines.map((each) {
          return instructionText(each);
        }).toList(),
      ),
    );
  }


  Widget instructionText(String text) {
    return Row(
      crossAxisAlignment: .center,
      spacing: 10,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              color: HexColor(lightBlue),
              shape: BoxShape.circle
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
