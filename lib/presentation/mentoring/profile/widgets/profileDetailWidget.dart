import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/global_passion.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/presentation/mentoring/profile/widgets/aboutExpertWidget.dart';
import 'package:reachx_embed/presentation/mentoring/profile/widgets/statusContainer.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistrationViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/profile/profileViewModel.dart';


class ProfileDetailWidget extends StatelessWidget {

  final ProfileViewModel profileViewModel;
  final ExpertEntity expertEntity;
  final ScrollController scrollController;

  ProfileDetailWidget({super.key, required this.profileViewModel, required this.expertEntity, required this.scrollController});

  bool playing = false;

  bool topics = false;

  ExpertRegistrationViewModel expertRegistrationViewModel = getIt();

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        spacing: 5,
        children: [
          const SizedBox(height: 80,),
          Text(
            expertEntity.name,
            style: TextStyle(
              fontSize: 20,
              color: HexColor(black),
              fontWeight: FontWeight.bold,
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: AboutExpertWidget(expertEntity: expertEntity),
            ),
          ),
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Obx(() {
          //       if(globalTopics.isNotEmpty) {
          //         return StatusContainer(profileViewModel: profileViewModel);
          //       } else{
          //         return const SizedBox.shrink();
          //       }
          //     }),
          //     // PassionWidget(
          //     //     height: height,
          //     //     profileViewModel: profileViewModel
          //     // ),
          //     // TopicListWidget(
          //     //     height: height,
          //     //     profileViewModel: profileViewModel,
          //     //     expertRegistrationViewModel: expertRegistrationViewModel
          //     // ),
          //   ],
          // ),
          const SizedBox(height: 90,),
        ],
      ),
    );
  }
}
