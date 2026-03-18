import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/global_passion.dart';
import 'package:reachx_embed/core/global_variables.dart';
import 'package:reachx_embed/core/helper/widgets/flagWavingGif.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/presentation/mentoring/profile/profileViewModel.dart';
import 'package:reachx_embed/presentation/commonWidgets/emptyUserWidget.dart';
import 'package:reachx_embed/presentation/mentoring/profile/widgets/profileExpertDetails.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistrationViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/signUpViewModel.dart';

class ProfileScreen extends StatefulWidget {

  static const route = "/profileScreen";

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileViewModel profileViewModel = getIt();
  SignUpViewModel signUpViewModel = getIt();
  ExpertRegistrationViewModel expertRegistrationViewModel = getIt();


  @override
  void initState() {
    profileViewModel.context = context;
    profileViewModel.getPhoneNo();
    profileViewModel.fetchProfileDetails();


    ever(expertRegistrationViewModel.saveResult, (bool isSaved) {
      if(mounted) {
        profileViewModel.fetchProfileDetails();
      }
    });

    ever(signUpViewModel.loginResponse, (bool isTrue) {
      if(mounted && checkpoint == "profile-limit") {
        profileViewModel.sendSubscriptionAlert("interim", "discover-limit");
        checkpoint = "homescreen";
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Obx(() {
        if(isGlobalLoading.value || profileViewModel.isLoading.value) {
          return const Center(
            child: FlagWavingGif(),
          );
        } else if(globalLoggedIn.value) {
          return ProfileExpertDetailsWidget(profileViewModel: profileViewModel);
        } else {
          return const EmptyUserWidget(isProfile: true,);
        }
      }),
    );
  }
}
