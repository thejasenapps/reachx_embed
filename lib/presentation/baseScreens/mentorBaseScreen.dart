import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/navigation/bottomNavBars/mentorBottomNavBar.dart';
import 'package:reachx_embed/core/navigation/nav_files/mentor/home_nav.dart';
import 'package:reachx_embed/core/navigation/navigationController.dart';
import 'package:reachx_embed/data/data_source/local/sharedPreferenceServices.dart';


class MentorBaseScreen extends StatefulWidget {
  static const route = "/mentor";

  const MentorBaseScreen({super.key});

  @override
  State<MentorBaseScreen> createState() => _MentorBaseScreenState();
}

class _MentorBaseScreenState extends State<MentorBaseScreen> with WidgetsBindingObserver {

  int navIndex = 0;
  final SharedPreferenceServices _sharedPreferenceServices = SharedPreferenceServices();

  final RxString currentRoute = RxString("/");

  late final AppLinks _appLinks;
  StreamSubscription<Uri?>? _sub;


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  // Future<void> onAppStart() async {
  //   final lastPaused = await _sharedPreferenceServices.getValue("shutdownTime");
  //
  //   if(lastPaused == null) {
  //     Logger().d("cold start");
  //   } else {
  //     final now = DateTime.now().millisecondsSinceEpoch;
  //     final diff = now - lastPaused;
  //
  //     if(diff > 5 * 1000) {
  //       Logger().d("cold start");
  //     }
  //     Logger().d("hot start");
  //   }
  // }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      extendBody: true,
      body: Obx(() {
        navIndex = NavigationController.to.currentIndex.value;
        return const HomeNav();
      }),
    );
  }
}
