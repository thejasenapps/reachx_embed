import 'package:flutter/material.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/meetingSetupViewModel.dart';

class MeetingLinkGiverWidget extends StatefulWidget {

  MeetingSetupViewModel meetingSetupViewModel;
  String meetingLink;
  DateTime activeTime;
  List<String> bookingIds;
  String topicId;
  String sessionType;

  MeetingLinkGiverWidget({
    super.key,
    required this.meetingSetupViewModel,
    required this.meetingLink,
    required this.activeTime,
    required this.bookingIds,
    required this.topicId,
    required this.sessionType
  });

  @override
  State<MeetingLinkGiverWidget> createState() => _MeetingLinkGiverWidgetState();
}

class _MeetingLinkGiverWidgetState extends State<MeetingLinkGiverWidget> {

  String selectedUrl = '';
  bool urlEditor = false;

  @override
  void initState() {
    selectedUrl = widget.meetingLink;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return urlEditor
      ? urlSaver()
      :  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "Meet link: $selectedUrl",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                urlEditor = true;
              });
            },
            icon: const Icon(
                Iconsax.edit,
              size: 18,
            )
        ),
        IconButton(
            onPressed: () {
              if(widget.activeTime.isBefore(DateTime.now())) {
                widget.meetingSetupViewModel.beginMeeting(widget.bookingIds, widget.meetingSetupViewModel.meetUrl);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Scheduled meeting is yet to commence"),
                      duration: Duration(seconds: 2),
                    )
                );
              }
            },
            icon: const Icon(
              Iconsax.export,
              size: 18,
            )
        )
      ],
    );
  }


  Widget urlSaver() {
    return TextField(
      controller: widget.meetingSetupViewModel.meetingUrlController,
      decoration: InputDecoration(
        hintText: "Paste the URL here",
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: HexColor(lightBlue),
          ),
          borderRadius: BorderRadius.circular(20)
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(20)
        ),
      ),
      onSubmitted: (text) async {

        String result = await widget.meetingSetupViewModel.saveUrl(
            widget.bookingIds,
            text,
            widget.topicId,
            widget.sessionType
        );
        setState(() {
          selectedUrl = text;
          urlEditor = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result))
        );
      },
    );
  }
}
