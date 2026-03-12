import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/widgets/customCalendar.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/meetingSetupViewModel.dart';


class AvailableSlotsWidget extends StatefulWidget {

  int eventId;
  int minutes;
  BookingEntity bookingEntity;

  AvailableSlotsWidget({super.key, required this.eventId, required this.minutes, required this.bookingEntity});

  @override
  State<AvailableSlotsWidget> createState() => _AvailableSlotsWidgetState();
}

class _AvailableSlotsWidgetState extends State<AvailableSlotsWidget> {

  MeetingSetupViewModel meetingSetupViewModel = getIt();
  List<dynamic> selectedAppointments = [];



  @override
  void initState() {
    meetingSetupViewModel.getSlots(widget.eventId, widget.minutes);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 500,
        width: 250,
        child: Obx(() {
          if(!meetingSetupViewModel.isAvailable.value) {
            return Column(
              children: [
                Center(
                  child: CircularProgressIndicator(
                    color: HexColor(loadingIndicatorColor),
                  ),
                ),
              ],
            );
          } else {
            return Customcalendar(
              calendarDataSource: meetingSetupViewModel.getSlotSource(),
              meetingSetupViewModel: meetingSetupViewModel,
              booking: widget.bookingEntity,
            );
          }
        }),
      ),
    );
  }
}

