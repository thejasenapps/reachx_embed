import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomAnimatedAlertBoxWidget extends StatefulWidget {
  final String path;
  final String label;

  const CustomAnimatedAlertBoxWidget({
    super.key,
    required this.label,
    required this.path
  });

  @override
  State<CustomAnimatedAlertBoxWidget> createState() => _CustomAnimatedAlertBoxWidgetState();
}

class _CustomAnimatedAlertBoxWidgetState extends State<CustomAnimatedAlertBoxWidget> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  bool showText = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);

    _controller.addStatusListener((status) async {
      if(status == AnimationStatus.completed) {
        setState(() {
          showText = true;
        });

        await Future.delayed(const Duration(seconds: 1));
        if(mounted) Navigator.pop(context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      elevation: 20,
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Lottie.asset(
            widget.path,
            controller: _controller,
            height: 160,
            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..forward(); // play once
            },
          ),

          AnimatedOpacity(
            opacity: showText ? 1 : 0,
            duration: const Duration(milliseconds: 500),
            child: Text(
              widget.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}