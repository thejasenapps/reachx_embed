import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/helper/intentMapUtils.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customElevatedButton.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/meetingSetupViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/widgets/detailsWidget.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/widgets/rescheduleAndCancelWidget.dart';

class OnsiteMeetingWidget extends StatefulWidget {

  MeetingSetupViewModel meetingSetupViewModel;
  BookingEntity bookingEntity;
  List<BookingEntity> groupEntity;
  bool expert;


  OnsiteMeetingWidget({super.key, required this.bookingEntity, required this.expert, required this.meetingSetupViewModel, required this.groupEntity});

  @override
  State<OnsiteMeetingWidget> createState() => _OnsiteMeetingWidgetState();
}

class _OnsiteMeetingWidgetState extends State<OnsiteMeetingWidget> {

  List<double> latLong = [];
  List<String> bookingUniqueIds = [];
  List<int> bookingIds = [];


  @override
  Widget build(BuildContext context) {

    DateTime activeTime =  widget.meetingSetupViewModel.activeTiming(widget.bookingEntity.start);

    if(widget.groupEntity.isNotEmpty) {
      for(BookingEntity booking in widget.groupEntity) {
        if(booking.topicId == widget.bookingEntity.topicId) {
          bookingUniqueIds.add(booking.bookingUniqueId!);
          bookingIds.add(booking.bookingId!);
        }
      }
    }

    return Column(
      spacing: 10,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: HexColor(containerBorderColor)),
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                DetailsWidget(bookingEntity: widget.bookingEntity, groupEntity: widget.groupEntity, isExpert: widget.expert,),
                RescheduleAndCancelWidget(
                  bookingEntity: widget.bookingEntity,
                  meetingSetupViewModel: widget.meetingSetupViewModel,
                  bookingIds: bookingIds.isEmpty ? [widget.bookingEntity.bookingId!] : bookingIds,
                  bookingUniqueIds: bookingUniqueIds.isEmpty ? [widget.bookingEntity.bookingUniqueId!] : bookingUniqueIds,
                ),
              ],
            ),
          ),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 5,
              children: [
                const Text("Location:"),
                Flexible(
                  child: Text(
                    widget.bookingEntity.location!,
                    style: TextStyle(
                      color: HexColor(lightBlue),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        CustomElevatedButton(
            label: "Go to Location",
            onTap: () async {
              await IntentUtils.launchGoogleMap(widget.bookingEntity.location!);
            }
        ),
        const SizedBox(height: 80,),
      ],
    );
  }
}
