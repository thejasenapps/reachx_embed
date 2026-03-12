import 'package:flutter/material.dart';

class DotGenerator extends CustomPainter{
  final Color color;
  final double radius;

  DotGenerator({required this.color, required this.radius});


  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2 ), radius, paint );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}



class DotWidget extends StatelessWidget {

  final double size;
  final Color color;

  const DotWidget({super.key, this.size = 10, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: DotGenerator(color: color, radius: size /2),
    );
  }
}
