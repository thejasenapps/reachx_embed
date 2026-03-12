import 'package:flutter/material.dart';

class DottedDividerPainter extends CustomPainter {
  final Color lineColor;
  final Color dotColor;

  DottedDividerPainter({
    required this.lineColor,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final paintDot = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    final centerY = size.height / 2;

    // Left dots
    canvas.drawCircle(Offset(130, centerY), 2, paintDot);

    // Right dots
    canvas.drawCircle(Offset(size.width - 130, centerY), 2, paintDot);

    // Line (leave space for dots)
    canvas.drawLine(
      Offset(120, centerY),
      Offset(size.width - 120, centerY),
      paintLine,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
