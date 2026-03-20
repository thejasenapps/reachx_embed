import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/presentation/mentoring/booked/bookedScheduleScreen.dart';
import 'package:reachx_embed/presentation/commonWidgets/editScreen.dart';
import 'package:reachx_embed/presentation/commonWidgets/topicEditScreen.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistration.dart';
import 'package:reachx_embed/presentation/mentoring/expertDetail/momentsViewScreen.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/homeScreen.dart';
import 'package:reachx_embed/presentation/mentoring/booking/bookingDialogScreen.dart';
import 'package:reachx_embed/presentation/mentoring/expertDetail/expertDetailScreen.dart';
import 'package:reachx_embed/presentation/mentoring/meetingSetup/meetingSetupScreen.dart';
import 'package:reachx_embed/presentation/mentoring/profile/profileScreen.dart';
import 'package:reachx_embed/presentation/mentoring/sessionDetail/SessionDetailScreen.dart';
import 'package:reachx_embed/presentation/mentoring/shareTemplate/shareTemplateScreen.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/signUpScreen.dart';
import 'package:reachx_embed/presentation/mentoring/topic_List/topicListScreen.dart';


class HomeNav extends StatelessWidget {
  const HomeNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(NavIds.home),
      onGenerateRoute: (settings) {
        if(settings.name =='/ExpertDetail') {
          return GetPageRoute(
              settings: settings,
              page: () => ExpertDetailScreen(
                  arguments: settings.arguments as Map<String, dynamic>
              )
          );
        } else if(settings.name =='/bookingDetail') {
          return GetPageRoute(
              settings: settings,
              page: () => SessionDetailScreen(
                  arguments: settings.arguments as Map<String, dynamic>
              )
          );
        } else if(settings.name =='/paymentScreen') {
          return GetPageRoute(
              settings: settings,
              page: () => BookingDialogScreen(
                  bookingDetails: settings.arguments as Map<String, dynamic>
              )
          );
        } else if(settings.name == "/topicList"){
          return GetPageRoute(
              settings: settings,
              page: () => TopicListScreen(
                searchItem: (settings.arguments as String?) ?? '',
              )
          );
        } else if(settings.name == '/shareTemplate'){
          return GetPageRoute(
              settings: settings,
              page: () => ShareTemplateScreen(
                arguments: settings.arguments as Map<String, dynamic>,
              )
          );
        } else if(settings.name == '/editScreen'){
          return GetPageRoute(
              settings: settings,
              page: () => EditScreen(
                arguments: settings.arguments as Map<String, dynamic>,
              )
          );
        } else if(settings.name =='/ExpertRegistration') {
          return GetPageRoute(
              settings: settings,
              page: () => ExpertRegistration(
                arguments: settings.arguments as Map<String, dynamic>,
              )
          );
        }  else if(settings.name == '/topicEditScreen'){
          return GetPageRoute(
              settings: settings,
              page: () => TopicEditScreen(
                arguments: settings.arguments as Map<String, dynamic>,
              )
          );
        } else if(settings.name == '/meetingSetup') {
          return GetPageRoute(
              settings: settings,
              page: () => MeetingSetupScreen(
                arguments: settings.arguments as Map<String, dynamic>,
              )
          );
        }  else if(settings.name == '/bookedScheduleScreen') {
          return GetPageRoute(
              settings: settings,
              page: () => const BookedScheduleScreen()
          );
        } else if(settings.name == '/momentsView'){
          return GetPageRoute(
              settings: settings,
              page: () => MomentsViewScreen(
                arguments: settings.arguments as Map<String, dynamic>,
              )
          );
        } else if(settings.name =='/ExpertRegistration') {
          return GetPageRoute(
              settings: settings,
              page: () => ExpertRegistration(
                arguments: settings.arguments as Map<String, dynamic>,
              )
          );
        } if(settings.name ==SignUpScreen.route) {
          return GetPageRoute(
              settings: settings,
              page: () => SignUpScreen(
                arguments: settings.arguments as Map<String, dynamic>,
              )
          );
        } else if(settings.name == "/profileScreen") {
          return GetPageRoute(
              settings: settings,
              page: () =>  const ProfileScreen()
          );
        } else {
          return GetPageRoute(
              settings: settings,
              page: () => const HomeScreen()
          );
        }
      },
    );
  }
}
