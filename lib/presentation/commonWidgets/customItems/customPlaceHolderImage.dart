import 'package:flutter/material.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class CustomPlaceHolderImage extends StatelessWidget {
  const CustomPlaceHolderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Icon(
      Iconsax.image,
      color: HexColor(lightBlue),
    );
  }
}
