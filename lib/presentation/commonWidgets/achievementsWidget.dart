import 'package:flutter/material.dart';
import 'package:reachx_embed/presentation/commonWidgets/infoToolTip.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/widgets/textTilesWidget.dart';



class AchievementsWidget extends StatefulWidget {
  final dynamic viewModel;
  const AchievementsWidget({super.key, required this.viewModel});

  @override
  State<AchievementsWidget> createState() => _AchievementsWidgetState();
}

class _AchievementsWidgetState extends State<AchievementsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 10,
          children: [
            const Text("Achievements"),
            InfoToolTip(label: "Achievements that you want to showcase to others",),
          ],
        ),
        TextTilesWidget(tiles: widget.viewModel.achievements, label: "Personal/Academic/Professional")
      ],
    );
  }
}
