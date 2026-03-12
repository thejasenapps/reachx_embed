import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/widgets/customCalendar.dart';
import 'package:reachx_embed/core/helper/findPlatform.dart';
import 'package:reachx_embed/core/helper/widgets/flagWavingGif.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customElevatedButton.dart';
import 'package:reachx_embed/presentation/mentoring/sessionDetail/sessionDetailViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/sessionDetail/widgets/customDetailWidget.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/signUpViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/sessionDetail/widgets/groupSlotsWidget.dart';
import 'package:reachx_embed/presentation/commonWidgets/backNavigationWidget.dart';



class SessionDetailScreen extends StatefulWidget {

  static const route = "/bookingDetail";
  Map<String, dynamic> arguments;

  SessionDetailScreen({super.key, required this.arguments});

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {

  SessionDetailViewModel sessionDetailViewModel = getIt();
  SignUpViewModel signUpViewModel = getIt();

  List<dynamic> selectedAppointments = [];




  @override
  void initState() {

    if(widget.arguments["sessionType"] != "group") {
      sessionDetailViewModel.getSlots(widget.arguments["eventId"], widget.arguments["minutes"]);
    }

    ever(signUpViewModel.loginResponse, (bool isSaved) {
      if(mounted) {
        sessionDetailViewModel.confirmBooking(context, widget.arguments);
      }
    });

    super.initState();
  }


  String name = '';

  List<DateTime> _getBlackListedDays() {
    List<DateTime> blackList = [];

    DateTime today = DateTime.now();
    for(int i = 0; i < 60; i++) {
      DateTime date = today.add(Duration(days: i));

      if(date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
        blackList.add(date);
      }
    }

    return blackList;
  }


  @override
  Widget build(BuildContext context) {

    final containerHeight = findPlatform();


    if(widget.arguments["sessionType"] != "group") {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              border: Border.all(color: HexColor(containerBorderColor), width: 2),
            ),
            height: containerHeight,
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              leading: BackNavigationWidget(context: context),
              title: Text(
                "Select schedule",
                style: TextStyle(
                  color: HexColor(black),
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        body: Obx(() {
          if(sessionDetailViewModel.isLoading.value) {
            return const Center(child: FlagWavingGif(),);
          } else {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 550,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: HexColor(containerBorderColor),
                                width: 2
                            )
                        ),
                        child: Customcalendar(
                          calendarDataSource: sessionDetailViewModel.getSlotSource(),
                          sessionDetailViewModel: sessionDetailViewModel,
                        ),
                      ),
                    ),
                  ),
                  CustomElevatedButton(
                      label: "Book",
                      onTap: () {
                        if(sessionDetailViewModel.scheduledTime.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Fix the schedule first"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          sessionDetailViewModel.confirmBooking(context, widget.arguments);
                        }
                      }
                  ),
                  const SizedBox(height: 100,)
                ],
              ),
            );
          }
        }),
      );
    } else {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              border: Border.all(color: HexColor(containerBorderColor), width: 2),
            ),
            height: containerHeight,
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              leading: BackNavigationWidget(context: context),
              title: Text(
                "Book Slots",
                style: TextStyle(
                  color: HexColor(black),
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 10,
            children: [
              CustomDetailWidget(bookingDetails: widget.arguments),
              GroupSlotsWidget(sessionDetailViewModel: sessionDetailViewModel, slotLeft: widget.arguments["groupSlotLeft"]),
              const Spacer(),
              CustomElevatedButton(
                  label: "Book",
                  onTap: () => sessionDetailViewModel.confirmBooking(context, widget.arguments)
              ),
              const SizedBox(height: 100,)
            ],
          ),
        )
      );
    }
  }
}

