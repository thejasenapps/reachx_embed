import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customElevatedButton.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/meetingSetupViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/widgets/detailsWidget.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/widgets/meetingLinkGiverWidget.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/widgets/rescheduleAndCancelWidget.dart';

class OnlineMeetingWidget extends StatefulWidget {

  MeetingSetupViewModel meetingSetupViewModel;
  BookingEntity bookingEntity;
  List<BookingEntity> groupEntity;
  bool expert;

  OnlineMeetingWidget({super.key, required this.bookingEntity, required this.groupEntity, required this.expert, required this.meetingSetupViewModel});

  @override
  State<OnlineMeetingWidget> createState() => _OnlineMeetingWidgetState();
}

class _OnlineMeetingWidgetState extends State<OnlineMeetingWidget> {

  List<String> bookingUniqueIds = [];
  List<int> bookingIds = [];

  @override
  Widget build(BuildContext context) {

    DateTime activeTime =  widget.meetingSetupViewModel.activeTiming(widget.bookingEntity.start);
    widget.meetingSetupViewModel.meetUrl = widget.bookingEntity.meetingUrl!;

    if(widget.groupEntity.isNotEmpty) {
      for(BookingEntity booking in widget.groupEntity) {
        if(booking.topicId == widget.bookingEntity.topicId) {
          bookingUniqueIds.add(booking.bookingUniqueId!);
          bookingIds.add(booking.bookingId!);
        }
      }
    }

    return Column(
      spacing: 20,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: HexColor(containerBorderColor)),
            color: Colors.white
          ),
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: DetailsWidget(bookingEntity: widget.bookingEntity, groupEntity: widget.groupEntity, isExpert: widget.expert,),
              ),
              RescheduleAndCancelWidget(
                bookingEntity: widget.bookingEntity,
                meetingSetupViewModel: widget.meetingSetupViewModel,
                bookingIds: bookingIds.isEmpty ? [widget.bookingEntity.bookingId!] : bookingIds,
                bookingUniqueIds: bookingUniqueIds.isEmpty ? [widget.bookingEntity.bookingUniqueId!] : bookingUniqueIds,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: HexColor(containerBorderColor)),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: widget.expert
                      ? MeetingLinkGiverWidget(
                    meetingSetupViewModel: widget.meetingSetupViewModel,
                    bookingIds: bookingUniqueIds.isEmpty ? [widget.bookingEntity.bookingUniqueId!] : bookingUniqueIds,
                    meetingLink: widget.meetingSetupViewModel.meetUrl, activeTime: activeTime,
                    topicId: widget.bookingEntity.topicId!,
                    sessionType: widget.bookingEntity.sessionType!,
                  )
                      :  RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 15),
                        children: [
                          const TextSpan(
                            text: "Meeting Link: ",
                            style: TextStyle(color: Colors.black)
                          ),
                          TextSpan(
                              text: widget.meetingSetupViewModel.meetUrl,
                              style: TextStyle(color: HexColor(lightBlue))
                          ),
                        ]
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
        CustomElevatedButton(
            label: "Join Meeting",
            onTap: () {
              if(activeTime.isBefore(DateTime.now())) {
                widget.meetingSetupViewModel.beginMeeting(bookingUniqueIds.isNotEmpty ? bookingUniqueIds : [widget.bookingEntity.bookingUniqueId!], widget.meetingSetupViewModel.meetUrl);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Scheduled meeting is yet to commence"),
                      duration: Duration(seconds: 2),
                    )
                );
              }
            }
        ),
      ],
    );
  }


  Widget customStartButton(VoidCallback onTap, String label, DateTime activeTime) {
    return ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )
          ),
          maximumSize: WidgetStateProperty.all<Size>(
            const Size(300, 50),
          ),
          minimumSize: WidgetStateProperty.all(
              const Size(150, 50)
          ),
          backgroundColor: WidgetStateProperty.all(
              activeTime.isBefore(DateTime.now()) ? HexColor(buttonColor) : HexColor(containerBorderColor)
          ),
        ),
        child: Text(
          label,
          style:  TextStyle(
              fontSize: 12,
              color: activeTime.isBefore(DateTime.now()) ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w900
          ),
        )
    );
  }
}
