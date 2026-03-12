import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PassionTypeToggleWidget extends StatefulWidget {

  final dynamic viewModel;
  final void Function(int index)? onToggle;

  const PassionTypeToggleWidget({
    super.key,
    required this.viewModel,
    required this.onToggle
  });

  @override
  State<PassionTypeToggleWidget> createState() => _PassionTypeToggleWidgetState();
}

class _PassionTypeToggleWidgetState extends State<PassionTypeToggleWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Passionate By",
          style: TextStyle(
              color: HexColor(black),
              fontSize: 17,
              fontWeight: FontWeight.bold
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(30),
          ),
          width: 200,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: ToggleSwitch(
              initialLabelIndex: widget.viewModel.skillType.value == "professional" ? 0 : 1,
              totalSwitches: 2,
              minWidth: 100,
              cornerRadius: 20,
              activeBgColor: [HexColor(lightBlue)],
              inactiveBgColor: HexColor(containerBorderColor),
              labels: const ["Professional", "Life Skill"],
              customTextStyles: const [TextStyle(color: Colors.black, fontSize: 12)],
              onToggle: (index) {
                widget.onToggle!(index!);
              },
            ),
          ),
        ),
      ],
    );
  }
}
