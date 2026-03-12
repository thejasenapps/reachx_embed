import 'package:flutter/material.dart';


class SimpleDialogBoxWidget extends StatefulWidget {
  final String label;
  const SimpleDialogBoxWidget({super.key, required this.label});

  @override
  State<SimpleDialogBoxWidget> createState() => _SimpleDialogBoxWidgetState();
}

class _SimpleDialogBoxWidgetState extends State<SimpleDialogBoxWidget> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      if( Navigator.of(context).canPop()) {
        Navigator.pop(context);
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          const SizedBox(height: 5,),
          Text(
            widget.label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          // ElevatedButton(
          //   onPressed: () => Navigator.pop(context),
          //   child: Text(
          //     "Ok",
          //     style: TextStyle(
          //         color: HexColor(lightBlue)
          //     ),
          //   ),
          // ),
          const SizedBox(height: 5,),
        ],
      ),
    );
  }
}
