import 'package:flutter/material.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:super_tooltip/super_tooltip.dart';

class InfoToolTip extends StatefulWidget {

  String label;
  InfoToolTip({super.key, required this.label});

  @override
  State<InfoToolTip> createState() => _InfoToolTipState();
}

class _InfoToolTipState extends State<InfoToolTip> {

  SuperTooltip? toolTip;


  @override
  Widget build(BuildContext context) {
    return SuperTooltip(
        content: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Text(
                widget.label,
              maxLines: 2,
            ),
          ),
        ),
        style: const TooltipStyle(
          hasShadow: false,
        ),
        touchThroughAreaShape: ClipAreaShape.rectangle,
        child: Icon(
          Iconsax.info_circle,
          size: 15,
          color: HexColor(lightBlue),
        ),
    );
  }
}
