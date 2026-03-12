import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/mentoring/sessionDetail/sessionDetailViewModel.dart';

class GroupSlotsWidget extends StatefulWidget {

  SessionDetailViewModel sessionDetailViewModel;
  int slotLeft;
  GroupSlotsWidget({super.key, required this.sessionDetailViewModel, required this.slotLeft});

  @override
  State<GroupSlotsWidget> createState() => _GroupSlotsWidgetState();
}

class _GroupSlotsWidgetState extends State<GroupSlotsWidget> {



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: HexColor(containerBorderColor)),
        color: Colors.grey,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Confirm the slot:"),
            Text(
              "${widget.sessionDetailViewModel.noOfGroupSlots.toString()} slot",
            ),
          ],
        ),
      ),
    );
  }
}
