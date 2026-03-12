import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';

class JournalNavBottomBar extends StatelessWidget {
  const JournalNavBottomBar({super.key});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        height: 60,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[300]!)
        ),
        constraints: const BoxConstraints(
            maxHeight: 55,
            minWidth: 50
        ),
        child: Icon(
          Iconsax.home,
          size: 25,
          color: HexColor(mainColor),
        ),
      ),
    );
  }
}
