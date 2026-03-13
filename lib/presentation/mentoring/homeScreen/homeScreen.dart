import 'package:flutter/material.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/global_passion.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/presentation/commonWidgets/confirmationBox.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistration.dart';
import 'package:reachx_embed/presentation/mentoring/booked/bookedViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/expertDetail/expertDetailScreen.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/homeScreenViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/widgets/bookedContainerDisplay.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/widgets/menuButtonWidget.dart';
import 'package:reachx_embed/presentation/mentoring/profile/profileScreen.dart';
import 'package:reachx_embed/presentation/mentoring/profile/profileViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/widgets/searchWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const route =
      '/HomeScreen'; // Route name for navigating to HomeScreen.

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenViewModel homeScreenViewModel = getIt();
  ProfileViewModel profileViewModel = getIt();
  BookedViewModel bookedViewModel = getIt();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    homeScreenViewModel.getPopularCategories();
    bookedViewModel.getSessionsBookings();

    if (globalUri.value != Uri()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigateToExpert();
      });
    }

    if (toExpertDetail.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.toNamed(ExpertDetailScreen.route, id: NavIds.home, arguments: {
          "uniqueId": inviteeExpertId,
          "topicId": inviteetopicId
        });
      });

      toExpertDetail.value = false;
    }
  }

  void navigateToExpert() {
    final expertId = globalUri.value.queryParameters['expertId'];
    final topicId = globalUri.value.queryParameters['passion'];

    if (expertId != null && topicId != null) {
      Get.toNamed(ExpertDetailScreen.route,
          id: NavIds.home,
          arguments: {"uniqueId": expertId, "topicId": topicId});

      globalUri.value = Uri();
    }
  }

  double? phoneHeight;
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    phoneHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * (isVisible ?  0.53 : 0.45),
              decoration: BoxDecoration(
                  color: HexColor(containerColor),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0.2,
                        blurRadius: 5,
                        offset: const Offset(0, 3))
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  spacing: 40,
                  children: [
                    const SizedBox(
                      height: 1,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: MenuButtonWidget(homeScreenViewModel: homeScreenViewModel)
                    ),
                    // if (phoneHeight! > 700)
                    //   const SizedBox(
                    //     height: 10,
                    //   ),
                    const Spacer(),
                    globalInstitutionId.value.isNotEmpty
                      ? Image.asset(
                        width: 130,
                        'lib/assets/images/reachX_homeLogo.png'
                    )
                      : Image.asset(
                        width: 130,
                        'lib/assets/images/reachX_homeLogo.png'
                    ),
                    SearchWidget(homeScreenViewModel: homeScreenViewModel),
                    const SizedBox()
                  ],
                ),
              ),
            ),
            Padding(
              // height: 600,
              padding: const EdgeInsets.all(8.0),
              child: BookedContainerDisplay(
                homeScreenViewModel: homeScreenViewModel,
                scrollController: scrollController,
                phoneHeight: phoneHeight!,
              ),
            ),
            Row(
              mainAxisAlignment: .center,
              spacing: 5,
              children: [
                Text(
                  "Powered by",
                  style: TextStyle(
                    color: HexColor(logoColor1),
                    fontSize: 18,
                  ),
                ),
                Image.asset(
                    width: 80,
                    'lib/assets/images/reachX_homeLogo.png'
                )
              ],
            ),
            const SizedBox(
              height: 80,
            )
          ],
        ),
      ),
    );
  }
}
