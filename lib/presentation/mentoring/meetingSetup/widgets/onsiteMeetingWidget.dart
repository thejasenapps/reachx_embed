import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/helper/intentMapUtils.dart';
import 'package:reachx_embed/core/helper/widgets/customDottedDividerWidget.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customElevatedButton.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/meetingSetupViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/widgets/detailsWidget.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/widgets/guidelinesWidget.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/widgets/rescheduleAndCancelWidget.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

  @override
  void initState() {
    if(widget.bookingEntity.sessionType!.toLowerCase() == "group") {
      widget.meetingSetupViewModel.getBookingGuidelines("offline-group");
    } else {
      widget.meetingSetupViewModel.getBookingGuidelines("offline-onetoone");
    }
    super.initState();
  }

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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: .start,
                    spacing: 5,
                    children: [
                      const Text(
                        "Location:",
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.bookingEntity.location!,
                          style: TextStyle(
                              color: HexColor(lightBlue),
                              fontSize: 16
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomElevatedButton(
                    label: "Go to Location",
                    onTap: () async {
                      await IntentUtils.launchGoogleMap(widget.bookingEntity.location!);
                    }
                ),
              ],
            ),
          ),
        ),
        Obx(() {
          return Skeletonizer(
              enabled: widget.meetingSetupViewModel.isGuidelinesLoading.value,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: HexColor(containerBorderColor)),
                    color: Colors.white
                ),
                margin: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    const SizedBox(height: 10,),
                    Center(
                      child: Text(
                        "Guidelines",
                        style: TextStyle(
                            color: HexColor(lightBlue),
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    CustomPaint(
                      painter: DottedDividerPainter(
                          lineColor: HexColor(containerBorderColor),
                          dotColor: HexColor(containerBorderColor)
                      ),
                    ),
                    GuidelinesWidget(
                        meetingSetupViewModel: widget.meetingSetupViewModel
                    ),
                    RescheduleAndCancelWidget(
                      bookingEntity: widget.bookingEntity,
                      meetingSetupViewModel: widget.meetingSetupViewModel,
                      bookingIds: bookingIds.isEmpty ? [widget.bookingEntity.bookingId!] : bookingIds,
                      bookingUniqueIds: bookingUniqueIds.isEmpty ? [widget.bookingEntity.bookingUniqueId!] : bookingUniqueIds,
                    ),
                    const SizedBox(height: 20,)
                  ],
                ),
              )
          );
        }),
        const SizedBox(height: 80,),
      ],
    );
  }
}
