import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class FlagFillingAnimation extends StatefulWidget {
  const FlagFillingAnimation({super.key});

  @override
  State<FlagFillingAnimation> createState() => _FlagFillingAnimationState();
}

class _FlagFillingAnimationState extends State<FlagFillingAnimation>  with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
        lowerBound: 0.5,
    ).. repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Path _createFlagPath(Size size) {
    final Path path = Path();

    final double poleWidth = size.width * 0.15; // pole thickness
    final double flagBodyWidth = size.width * 0.25; // rectangular part of flag
    final double triangleWidth = size.width * 1.2; // width of triangle tip
    final double flagHeight = size.height; // total height

    // --- Rectangle (flag body) ---
    path.moveTo(poleWidth, 0); // top-left of flag
    path.lineTo(poleWidth + flagBodyWidth, 0); // top-right of rectangle
    path.lineTo(poleWidth + flagBodyWidth, flagHeight); // bottom-right of rectangle
    path.lineTo(poleWidth, flagHeight); // bottom-left of rectangle
    path.close();

    // --- Triangle (flag tip) ---
    final Path triangle = Path();
    triangle.moveTo(poleWidth + flagBodyWidth, 0); // top of triangle base
    triangle.lineTo(poleWidth + flagBodyWidth + triangleWidth, flagHeight / 4); // triangle tip
    triangle.lineTo(poleWidth + flagBodyWidth, flagHeight / 2); // bottom of triangle base
    triangle.close();

    // Combine both shapes
    path.addPath(triangle, Offset.zero);

    return path;
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return SizedBox(
              width: 40,
              height: 100,
              child: LiquidCustomProgressIndicator(
                  value: _controller.value,
                  valueColor: AlwaysStoppedAnimation(HexColor(mainColor)),
                  backgroundColor: Colors.grey[200],
                  direction: Axis.vertical,
                  shapePath: _createFlagPath(const Size(25, 70))
              ),
            );
          }
      ),
    );
  }
}
