import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class BuildShiningText extends StatefulWidget {
  final String text;
  final double size;
  bool? reverse;

  BuildShiningText({
    super.key,
    required this.text,
    required this.size,
    this.reverse
  });

  @override
  State<BuildShiningText> createState() => _BuildShiningTextState();
}

class _BuildShiningTextState extends State<BuildShiningText> with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2)
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final colorList = widget.reverse != true
        ? [
      HexColor(specialColor),
      HexColor(specialColor_light),
      HexColor(specialColor),
    ]
        : [
      HexColor(specialColor_light),
      HexColor(specialColor),
      HexColor(specialColor_light),
    ];

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [
                    (_controller.value - 0.2).clamp(0.0, 1.0),
                    _controller.value,
                    (_controller.value + 0.2).clamp(0.0, 1.0)
                  ],
                  colors: colorList
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: Text(
              widget.text,
              style: TextStyle(
                color: HexColor(specialColor),
                fontSize: widget.size,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
    );
  }
}
