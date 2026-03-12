import 'package:flutter/material.dart';

class SearchClueWidget extends StatefulWidget {

  String label;

  SearchClueWidget({super.key, required this.label});

  @override
  State<SearchClueWidget> createState() => _SearchClueWidgetState();
}

class _SearchClueWidgetState extends State<SearchClueWidget> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: const ButtonStyle(

      ),
      child: Text(
        widget.label,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}
