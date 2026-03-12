import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/domain/entities/sessionEntity.dart';
import 'package:reachx_embed/presentation/mentoring/shareTemplate/shareTemplateViewModel.dart';

class SessionStatusWidget extends StatelessWidget {
  ShareTemplateViewModel shareTemplateViewModel;
  SessionEntity sessionEntity;
  SessionStatusWidget({super.key, required this.shareTemplateViewModel, required this.sessionEntity});

  @override
  Widget build(BuildContext context) {

    List<String> status = shareTemplateViewModel.sessionStatus(sessionEntity);


    return status.isEmpty
      ? Container(
      decoration: BoxDecoration(
          color: HexColor(templateContainerColor2),
          borderRadius: BorderRadius.circular(10)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: const Text(
        "Sessions available on ReachX platform",
        style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold
        ),
        textAlign: TextAlign.center,
      ),
    )
      : Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              color: HexColor(templateContainerColor2)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: Text(
            status[0],
            style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: HexColor(templateContainerColor1)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: Text(
            status[1],
            style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );
  }
}
