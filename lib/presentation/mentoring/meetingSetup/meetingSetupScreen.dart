import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/presentation/mentoring/booked/bookedScheduleScreen.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/meetingSetupViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/widgets/onlineMeetingWidget.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/widgets/onsiteMeetingWidget.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/presentation/commonWidgets/backNavigationWidget.dart';
import 'package:skeletonizer/skeletonizer.dart';


class MeetingSetupScreen extends StatefulWidget {

  static const route = "/meetingSetup";
  Map<String, dynamic> arguments;

  MeetingSetupScreen({super.key, required this.arguments});

  @override
  State<MeetingSetupScreen> createState() => _MeetingSetupScreenState();
}

class _MeetingSetupScreenState extends State<MeetingSetupScreen> {
  MeetingSetupViewModel meetingSetupViewModel = getIt();


  @override
  void initState() {
    BackButtonInterceptor.add(interceptor);

    if(widget.arguments["bookingId"] != null) {
      meetingSetupViewModel.getBookingDetails(widget.arguments["bookingId"]);
    } else {
      meetingSetupViewModel.bookingEntity = widget.arguments["booking"];
      meetingSetupViewModel.groupEntities = widget.arguments["groupBooking"] ?? [];
      meetingSetupViewModel.isExpert = widget.arguments["isExpert"] ?? false;
    }
    super.initState();



    ever(meetingSetupViewModel.rescheduleNotify, (bool notify) {
      if(mounted) {
        // Get.offAllNamed(
        //   BookedScheduleScreen.route,
        //   id: NavIds.bookings,
        // );

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
                meetingSetupViewModel.userId == meetingSetupViewModel.bookingEntity!.expertId
                    ? "Reschedule in Progress"
                    : "Reschedule confirmed"
            ))
        );
      }
    });


    // ever(meetingSetupViewModel.cancelled, (bool cancel) {
    //   if(mounted) {
    //     Get.offAllNamed(
    //       BookedScheduleScreen.route,
    //       id: NavIds.bookings,
    //     );
    //   }
    // });
  }

  bool interceptor( bool stopDefaultEvent, RouteInfo info) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(interceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            leading: BackNavigationWidget(context: context),
            title: Text(
              "Session Details",
              style: TextStyle(
                color: HexColor(black),
                fontSize: 15,
              ),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Obx(() {
              return Skeletonizer(
                  enabled: meetingSetupViewModel.isLoading.value,
                  child: meetingSetupViewModel.bookingEntity != null
                      ? meetingSetupViewModel.bookingEntity!.session == "online"
                      ? OnlineMeetingWidget(
                    bookingEntity: meetingSetupViewModel.bookingEntity!,
                    expert: meetingSetupViewModel.isExpert,
                    meetingSetupViewModel: meetingSetupViewModel,
                    groupEntity: meetingSetupViewModel.groupEntities,
                  )
                      : OnsiteMeetingWidget(
                    bookingEntity: meetingSetupViewModel.bookingEntity!,
                    expert: meetingSetupViewModel.isExpert,
                    meetingSetupViewModel: meetingSetupViewModel,
                    groupEntity: meetingSetupViewModel.groupEntities,
                  )
                      : Center(
                    child: Text(
                      "No data found",
                      style: TextStyle(
                          color: HexColor(lightBlue),
                          fontSize: 14
                      ),
                    ),
                  )
              );
            }),
          ),
        )
    );
  }
}