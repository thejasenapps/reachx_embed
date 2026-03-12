import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/presentation/mentoring/sessionDetail/sessionDetailViewModel.dart';

class ScheduleSectionWidget extends StatefulWidget {

  SessionDetailViewModel sessionDetailViewModel;


  ScheduleSectionWidget({super.key, required this.sessionDetailViewModel});

  @override
  State<ScheduleSectionWidget> createState() => _ScheduleSectionWidgetState();

}

class _ScheduleSectionWidgetState extends State<ScheduleSectionWidget> {




  @override
  Widget build(BuildContext context) {

    return Obx(() {

      if( widget.sessionDetailViewModel.selectedDate.value.isNotEmpty) {

        final startTime = "${widget.sessionDetailViewModel.scheduledTime[0].hour}: ${widget.sessionDetailViewModel.scheduledTime[0].minute}";
        final endTime = "${widget.sessionDetailViewModel.scheduledTime[1].hour}: ${widget.sessionDetailViewModel.scheduledTime[1].minute}";

        return Container(
          color: Colors.grey[400],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text("Time Range:"),
                Text("$startTime : $endTime"),
                const Text("Date:"),
                Text(widget.sessionDetailViewModel.selectedDate.value)
              ],
            ),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}
