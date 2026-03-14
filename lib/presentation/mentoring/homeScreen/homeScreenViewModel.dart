import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/enums.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/global_passion.dart';
import 'package:reachx_embed/core/global_variables.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/institutionEntity.dart';
import 'package:reachx_embed/domain/homeScreen/homeScreenEntity.dart';
import 'package:reachx_embed/domain/homeScreen/homeScreenUsecase.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistration.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistrationViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/profile/profileViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/booked/bookedViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/topic_List/topicListScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreenViewModel extends GetxController{

  final HomeScreenUsecase homeScreenUsecase = HomeScreenUsecase();
  late final String userId;
  ProfileViewModel profileViewModel = getIt();
  ExpertRegistrationViewModel expertRegistrationViewModel = getIt();
  BookedViewModel bookedViewModel = getIt();

  PopularCategoryEntity? popularCategories;

  late Map<String, String> links;  // To store tutorial links, if needed later.
  int totalBanners = 0;
  int batchSize = 4;
  int len = 0;
  InstitutionEntity? institutionEntity;

  RxBool isLoading = true.obs;
  RxBool result = false.obs;
  RxBool expert = false.obs;
  RxBool isInstitutionLoading = false.obs;


  // Checks if the user is logged in and assigns their status accordingly.
  Future<void> isLogged(BuildContext context) async {
    bool isLoggedIn = await homeScreenUsecase.isLoggedIn();

    if(!isLoggedIn) {
      checkpoint = "homeScreen";
      if (!context.mounted) return;  // Ensures context is still mounted before navigation.
      Get.toNamed(
        '/SignUpScreen',
        arguments: {
          "type": AuthenticationType.login,
          "isHomeFlow": true,
        },
      );
    }
  }


  // Fetches popular categories from the backend.
  Future<void> getPopularCategories() async {
    try{
      isLoading.value = true;
      popularCategories = await homeScreenUsecase.getPopularCategories();
      isLoading.value = false;
    } catch(e) {
      print(e);
    }
  }


  void appLinkListen(String value) {
    Get.toNamed(
      TopicListScreen.route,
      id: NavIds.home,
      arguments: {}
    );
  }

  bool checkForExpertRegistration() {
    if(globalExpertEntity.value.achievements.isNotEmpty
        && globalExpertEntity.value.languages.isNotEmpty
        && globalExpertEntity.value.intro.isNotEmpty) {
      return true;
    }
    return false;
  }


  Future<TrendingProfilesListEntity> fetchTrendingProfiles() async {
    Results results = await  homeScreenUsecase.fetchTrendingProfiles();

    if(results is SuccessState) {
      return results.value as TrendingProfilesListEntity;
    } else {
      return TrendingProfilesListEntity(trendingProfilesList: []);
    }
  }





  void logOut() async {
    result.value = await homeScreenUsecase.logOut();

    if(result.value) {
      // fetchProfileDetails();
      bookedViewModel.latestBooking.clear();
      expert.value = false;
      isExpert.value = false;
      signal.value = false;


      globalExpertEntity.value = ExpertEntity(
          uniqueId: '',
          name: '',
          minutes: 60,
          topics: [],
          intro: '',
          location: "unknown",
          experience: 0,
          languages: [],
          achievements: [],
          imageFile: ''
      );

      globalTopics.clear();
      globalPassions.clear();
      globalSessions.clear();
      globalUserId.value = '';
      globalStreakCount = (-1).obs;
      globalSubscriptionEntity.clear();
      globalSubscriptionStatus.value = SubscriptionStatus.beginner;
    }

  }


  void fetchProfileDetails() async {
    isLoading.value = true;
    globalExpertEntity.value = await homeScreenUsecase.fetchExpertProfile();

    final expertEntity = globalExpertEntity.value;

    if(globalExpertEntity.value.name.isNotEmpty
        && globalExpertEntity.value.intro.isNotEmpty
        && globalExpertEntity.value.achievements.isNotEmpty
        && globalExpertEntity.value.location.isNotEmpty) {
      isExpert.value = true;
    }
    // If expert profile is not found, fetch user profile.
    if (globalExpertEntity.value.topics!.isEmpty) {
      expertReg = false;
      expert.value = false;
      globalTopics.clear();
    } else {
      status = globalExpertEntity.value.status!;
      expertReg = true;
      homeScreenUsecase.saveOnline("online", status);
      expert.value = true;
      isExpert.value = true;
    }
    isLoading.value = false;
  }


  Future<bool> openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    } else {
      return false;
    }
  }


  Future<void> openWhatsApp(String type) async {
    final String phone = officialPhone.isNotEmpty ? officialPhone : "916238637381";
    late final String message;
    if(type == "support") {
      message = "Hello, ReachX Support";
    }
    final Uri url = Uri.parse("https://wa.me/$phone?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception("WhatsApp is not installed");
    }
  }


  Future<void> getInstitutionDetails(String institutionId) async {
    isInstitutionLoading.value = true;
    institutionEntity = await homeScreenUsecase.getInstitution(institutionId);
    isInstitutionLoading.value = false;
  }
}
