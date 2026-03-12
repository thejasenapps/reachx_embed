import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/rescheduleStatus.dart';
import 'package:reachx_embed/core/helper/dateAndTimeConvertors.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/presentation/commonWidgets/confirmationBox.dart';
import 'package:reachx_embed/presentation/commonWidgets/simpleDialogBoxWidget.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/widgets/availableSlotsBookedWidget.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/meetingSetupViewModel.dart';

class RescheduleAndCancelWidget extends StatefulWidget {

  BookingEntity bookingEntity;
  MeetingSetupViewModel meetingSetupViewModel;
  List<String> bookingUniqueIds;
  List<int> bookingIds;

  RescheduleAndCancelWidget({super.key, required this.bookingEntity, required this.meetingSetupViewModel, required this.bookingIds, required this.bookingUniqueIds});

  @override
  State<RescheduleAndCancelWidget> createState() => _RescheduleAndCancelWidgetState();
}

class _RescheduleAndCancelWidgetState extends State<RescheduleAndCancelWidget> {


  Map<String, dynamic> dateTime = {};


  @override
  void initState() {
    if(widget.bookingEntity.rescheduleStatus == RescheduleStatus.ongoing && widget.bookingEntity.rescheduleInitiator != true) {
      dateTime = _dateAndTimeConvertors.fromUTC(widget.bookingEntity.rescheduleDate!);
    }

    getId();
    super.initState();
  }


  void getId() async {
    widget.meetingSetupViewModel.userId = await FirebaseAuthentication().getFirebaseUid();
  }

  final DateAndTimeConvertors _dateAndTimeConvertors = DateAndTimeConvertors();

  @override
  Widget build(BuildContext context) {

    return widget.bookingEntity.rescheduleStatus == RescheduleStatus.started
        ? widget.meetingSetupViewModel.userId != widget.bookingEntity.expertId
          ?  Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: HexColor(containerBorderColor))
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 5,
              children: [
                Text(
                  "Reschedule Alert",
                  style: TextStyle(
                      color: HexColor(black),
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Passionate has requested for a reschedule",
                    style: TextStyle(
                        color: HexColor(black),
                        fontSize: 16
                    ),
                  ),
                ),
                const Text(
                  "*This booking will be automatically cancelled if no action is performed",
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 10
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if(widget.bookingEntity.sessionType != "group")
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ElevatedButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => AvailableSlotsWidget(
                                eventId: widget.bookingEntity.eventId!,
                                minutes: widget.bookingEntity.lengthInMinutes!,
                                bookingEntity: widget.bookingEntity,
                              )
                          ),
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                    side: BorderSide(color: HexColor(containerBorderColor)),
                                    borderRadius: BorderRadius.circular(20)
                                )
                            ),
                            backgroundColor: WidgetStateProperty.all(Colors.grey[100]),
                          ),
                          child: Text(
                            "Reschedule Session",
                            style: TextStyle(color: HexColor(lightBlue), fontSize: 12),
                          ),
                        ),
                      ),
                    // Cancel button
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: customDeleteButton()
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )
        :  Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: HexColor(containerBorderColor))
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 5,
              children: [
                Text(
                  "Reschedule Alert",
                  style: TextStyle(
                      color: HexColor(black),
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Waiting for the reschedule confirmation from client",
                    style: TextStyle(
                        color: HexColor(black),
                        fontSize: 16
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
        :  widget.bookingEntity.expertId == widget.meetingSetupViewModel.userId
          ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if(widget.bookingEntity.sessionType != "group")
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  onPressed: () => widget.meetingSetupViewModel.onTapped(widget.bookingEntity),
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                            side: BorderSide(color: HexColor(containerBorderColor)),
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                    backgroundColor: WidgetStateProperty.all(Colors.grey[100]),
                  ),
                  child: Text(
                    "Reschedule Session",
                    style: TextStyle(color: HexColor(lightBlue), fontSize: 12),
                  ),
                ),
              ),
            // Cancel button
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: customDeleteButton()
            ),
          ],
        )
          : Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if(widget.bookingEntity.sessionType != "group")
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: ElevatedButton(
              onPressed: () {
                if(DateTime.parse(widget.bookingEntity.start).difference(DateTime.now()) > const Duration(minutes: 60)) {
                  showDialog(
                      context: context,
                      builder: (context) => AvailableSlotsWidget(
                        eventId: widget.bookingEntity.eventId!,
                        minutes: widget.bookingEntity.lengthInMinutes!,
                        bookingEntity: widget.bookingEntity,
                      )
                  );
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => const SimpleDialogBoxWidget(label: "Rescheduling is not allowed after the last 60 minutes")
                  );
                }
              },
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                        side: BorderSide(color: HexColor(containerBorderColor)),
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
                backgroundColor: WidgetStateProperty.all(Colors.grey[100]),
              ),
              child: Text(
                "Reschedule Session",
                style: TextStyle(color: HexColor(lightBlue), fontSize: 12),
              ),
            ),
          ),
        // Cancel button
        if(widget.bookingEntity.sessionType != "group")
          Padding(
              padding: const EdgeInsets.all(5.0),
              child: customDeleteButton()
          ),
      ],
    );

  }



  Widget customDeleteButton() {

    return ElevatedButton(
      onPressed: () async {
        bool? response = await showDialog(
          context: context,
          builder: (context) => ConfirmationBoxWidget(
              label: widget.meetingSetupViewModel.userId != widget.bookingEntity.attendeeId
                ? "Are you sure you want to cancel?\nCancelling might lead to user "
                  "dissatisfaction among those who booked you.\nWe recommend taking"
                  " a moment to reconsider before proceeding\n\nTo avoid confusion "
                  "and prevent others from booking the same date, you should reschedule"
                  " your availability from the Profile Edit section."
              : "Are you sure you want to cancel?\nWe recommend taking"
                  " a moment to reconsider before proceeding.",
              functionality: () async {
                if(DateTime.parse(widget.bookingEntity.start).difference(DateTime.now()) > const Duration(minutes: 60)) {
                  bool result = await  widget.meetingSetupViewModel.cancel(widget.bookingEntity, widget.bookingUniqueIds, widget.bookingIds, context);

                  if(result) {
                    Navigator.pop(context, true);
                  } else {
                    Navigator.pop(context, false);
                  }
                } else {

                  print(DateTime.now().difference(DateTime.parse(widget.bookingEntity.start)));

                  Navigator.pop(context, true);

                  showDialog(
                      context: context,
                      builder: (context) => const SimpleDialogBoxWidget(label: "No cancellation allowed after the last 60 minutes")
                  );
                }
              }
          ),
        );

        if(response != null && response) {
          Navigator.pop(context);
        }
      },
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
                side: BorderSide(color: HexColor(containerBorderColor)),
                borderRadius: BorderRadius.circular(20)
            )
        ),
        backgroundColor: WidgetStateProperty.all(
            Colors.grey[100]
        ),

      ),
      child: Text(
        "Cancel Session",
        style: TextStyle(
            color: HexColor(lightBlue),
            fontSize: 12
        ),
      ),
    );
  }

}
