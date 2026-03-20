import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/global_passion.dart';
import 'package:reachx_embed/core/helper/customSilverDelegate.dart';
import 'package:reachx_embed/core/helper/widgets/flagWavingGif.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistrationViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/homeScreenViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/widgets/expertRegistrationSwitch.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/widgets/trendingCarousalWidget.dart';
import 'package:reachx_embed/presentation/mentoring/topic_List/topicListScreen.dart';

class ExploreWidget extends StatefulWidget {

  HomeScreenViewModel homeScreenViewModel;

  ExploreWidget({super.key, required this.homeScreenViewModel});

  @override
  State<ExploreWidget> createState() => _ExploreWidgetState();
}

class _ExploreWidgetState extends State<ExploreWidget> {
  ExpertRegistrationViewModel expertRegistrationViewModel = getIt();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.homeScreenViewModel.getPopularCategories();
      ever(expertRegistrationViewModel.saveResult, (bool isSaved) {
        widget.homeScreenViewModel.getPopularCategories();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        popularCategories(widget.homeScreenViewModel),
      ],
    );
  }

  Widget popularCategories(HomeScreenViewModel homeScreenModel) {
    return Obx(() {
      if(homeScreenModel.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Center(
            child: FlagWavingGif(),
          ),
        );
      } else {
        if(homeScreenModel.popularCategories!.categories.isEmpty) {
          return const Center(
            child: Text("No data"),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TrendingCarousalWidget(
                  homeScreenViewModel: widget.homeScreenViewModel
              ),
              const SizedBox(height: 15,),
              Obx(() {
                if(globalLoggedIn.value) {
                  return const SizedBox.shrink();
                } else {
                  return  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      ExpertRegistrationSwitchWidget(
                          homeScreenViewModel: widget.homeScreenViewModel,
                          isExpert: false,
                          isTopicList: false
                      ),
                      Text(
                        "Click here to list your session",
                        style: TextStyle(
                            fontSize: 14,
                            color: HexColor(secondaryTextColor),
                            fontWeight: FontWeight.w300
                        ),
                      ),
                    ],
                  );
                }
              }),

            ],
          );
        }
      }
    });
  }
}
