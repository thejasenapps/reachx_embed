import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/presentation/commonWidgets/backNavigationWidget.dart';
import 'package:reachx_embed/presentation/mentoring/booked/bookedViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/booked/widgets/bookedListWidget.dart';
import 'package:reachx_embed/presentation/mentoring/booked/widgets/finishedListWidget.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistrationViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/signUpViewModel.dart';

class BookedScheduleScreen extends StatefulWidget {
  static const route = '/bookedScheduleScreen';

  const BookedScheduleScreen({super.key});

  @override
  State<BookedScheduleScreen> createState() => _BookedScheduleScreenState();
}

class _BookedScheduleScreenState extends State<BookedScheduleScreen>
    with SingleTickerProviderStateMixin {

  final BookedViewModel bookedViewModel = getIt();
  late TabController _tabController;

  SignUpViewModel signUpViewModel = getIt();
  ExpertRegistrationViewModel expertRegistrationViewModel= getIt();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    ever(signUpViewModel.loginResponse, (bool isSaved) {
      if(mounted) {
        resetTabs(refresh: true);
      }
    });

    ever(expertRegistrationViewModel.saveResult, (bool isSaved) {
      if(mounted) {
        resetTabs(refresh: true);
      }
    });

  }

  void resetTabs({bool refresh = false}) {
    _tabController.index = 0;

    if (refresh) {
      bookedViewModel.getSessionsBookings();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: BackNavigationWidget(context: context),
        title: const Text(
          "Bookings",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          side: BorderSide(
            color: HexColor(containerBorderColor),
            width: 1,
          ),
        ),
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: HexColor(mainColor),
          unselectedLabelColor: Colors.black,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 3, color: HexColor(mainColor)),
            insets: const EdgeInsets.symmetric(horizontal: 20),
            borderRadius: BorderRadius.circular(30),
          ),
          dividerHeight: 0,
          tabs: const [
            Tab(
              child: Text(
                "Upcoming",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Tab(
              child: Text(
                "Finished",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                BookedListWidget(
                    bookedViewModel: bookedViewModel, type: "appointments"),
                const SizedBox(height: 70),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                FinishedListWidget(bookedViewModel: bookedViewModel),
                const SizedBox(height: 70),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
