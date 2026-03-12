import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class CustomTopBar extends StatelessWidget {
  final String title;
  final BuildContext context;
  final Widget backNavigation;

  const CustomTopBar({
    super.key,
    required this.title,
    required this.context,
    required this.backNavigation
  });

  double findPlatform() {
    if(kIsWeb) {
      return 80;
    } else if(Platform.isIOS) {
      return 120;
    } else {
      return 80;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          border: Border.all(
              color: HexColor(containerBorderColor)
          )
      ),
      height: findPlatform(),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            backNavigation,
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16
              ),
            ),
            const SizedBox(
              width: 40,
            )
          ],
        ),
      ),
    );
  }
}
