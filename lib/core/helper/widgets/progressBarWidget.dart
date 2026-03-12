import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class ProgressBarWidget extends StatelessWidget {
  final int length;
  final int index;

  const ProgressBarWidget({
    super.key,
    required this.index,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) => customProgressContainer(i)),
    );
  }

  Widget customProgressContainer(int progressCount) {
    final bool isActive = progressCount <= index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 10,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: progressCount == 0 ? const Radius.circular(10) : Radius.zero,
          bottomLeft: progressCount == 0 ? const Radius.circular(10) : Radius.zero,
          topRight: progressCount == length - 1 ? const Radius.circular(10) : Radius.zero,
          bottomRight: progressCount == length - 1 ? const Radius.circular(10) : Radius.zero,
        ),
        color: isActive ? HexColor(specialColor) : Colors.grey[300],
      ),
    );
  }
}
