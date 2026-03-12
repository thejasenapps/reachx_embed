import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/commonWidgets/infoToolTip.dart';

class AudioRecorderDialog extends StatefulWidget {
  final dynamic viewModel;
  final void Function() onRecord;

  const AudioRecorderDialog({
    super.key,
    required this.viewModel,
    required this.onRecord
  });

  @override
  State<AudioRecorderDialog> createState() => _AudioRecorderDialogState();
}

class _AudioRecorderDialogState extends State<AudioRecorderDialog> with SingleTickerProviderStateMixin {

  late final CustomTimerController _timeController = CustomTimerController(
    vsync: this,
    begin: const Duration(seconds: 1),
    end: const Duration(seconds: 60),
    initialState: CustomTimerState.reset,
    interval: CustomTimerInterval.seconds,
  );


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: HexColor(containerBorderColor)),
          color: Colors.grey[100]
      ),
      width: double.infinity,
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 15,
            children: [
              Row(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Speak about your session in 30 sec",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  InfoToolTip(label: "Speaking about your session increases the chance of people reaching you.")
                ],
              ),

              Container(
                decoration: BoxDecoration(
                  color: HexColor(lightBlue),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),
                child: IconButton(
                    onPressed: () {
                      if (widget.viewModel.record) {
                        widget.viewModel.stopRecord();
                        setState(() {
                          widget.viewModel.record = false;
                          widget.viewModel.file.value = true;
                        });
                        widget.onRecord;
                        _timeController.reset();
                      } else {
                        widget.viewModel.startRecord();
                        setState(() {
                          widget.viewModel.record = true;
                        });
                        _timeController.start();
                      }
                    },
                    icon: Icon(
                      widget.viewModel.record ? Iconsax.pause : Iconsax.microphone,
                      size: 25,
                      color: Colors.white,
                    )
                ),
              ),
              Text(
                  "Tap to record",
                style: TextStyle(
                  color: Colors.grey[500]
                ),
              ),
            ],
          )
      ),
    );
  }
}
