import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/global_passion.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/presentation/commonWidgets/confirmationBox.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customPlaceHolderImage.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistration.dart';
import 'package:reachx_embed/presentation/mentoring/booked/bookedViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/expertDetail/expertDetailScreen.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/homeScreenViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/widgets/bookedContainerDisplay.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/widgets/menuButtonWidget.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/widgets/noSubscriptionAlertWidget.dart';
import 'package:reachx_embed/presentation/mentoring/profile/profileScreen.dart';
import 'package:reachx_embed/presentation/mentoring/profile/profileViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/widgets/searchWidget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const route =
      '/HomeScreen'; // Route name for navigating to HomeScreen.

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  with TickerProviderStateMixin {
  HomeScreenViewModel homeScreenViewModel = getIt();
  ProfileViewModel profileViewModel = getIt();
  BookedViewModel bookedViewModel = getIt();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    homeScreenViewModel.getPopularCategories();
    bookedViewModel.getSessionsBookings();

    checkForInstitution();

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

  void checkForInstitution() async {
    debugPrint("Loading");

    final result = await homeScreenViewModel.getInstitutionDetails();

    debugPrint("Loaded result: $result");

    if (!result) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        openBottomSheet(context);
      });
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

  void openBottomSheet(BuildContext context) {

    final AnimationController controller = BottomSheet.createAnimationController(this);
    controller.duration = const Duration(milliseconds: 1000);


    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        barrierColor: Colors.black.withOpacity(0.1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(20)
          ),
        ),
        transitionAnimationController: controller,
        builder: (context) {
          return const NoSubscriptionAlertWidget();
        }
    );

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
                  spacing: 10,
                  children: [
                    Obx(() {
                      return Visibility(
                        visible: globalUserId.value.isNotEmpty,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: MenuButtonWidget(homeScreenViewModel: homeScreenViewModel)
                        ),
                      );
                    }),

                    Obx(() {
                      return Skeletonizer(
                        enabled: homeScreenViewModel.isInstitutionLoading.value,
                        child: homeScreenViewModel.institutionEntity != null && homeScreenViewModel.institutionEntity!.name.isNotEmpty
                            ? Column(
                              mainAxisSize: .min,
                              crossAxisAlignment: .center,
                              spacing: 10,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: homeScreenViewModel.institutionEntity!.logo,
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>  const Center(
                                    child: CustomPlaceHolderImage(),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(color: HexColor(containerBorderColor)),
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(60)
                                      ),
                                      child: const Icon(
                                        Icons.person, size: 40, color: Colors.grey,
                                      )
                                  ),
                                ),
                                Text(
                                  homeScreenViewModel.institutionEntity!.name,
                                  style: TextStyle(
                                      color: HexColor(specialColor),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24
                                  ),
                                ),
                              ],
                            )
                            : Column(
                          mainAxisSize: .min,
                          crossAxisAlignment: .center,
                          spacing: 10,
                          children: [
                            Image.asset(
                              height: 160,
                              width: 160,
                              "lib/assets/images/splash_logo.png"
                            ),
                          ],
                        ),
                      );
                    }),
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
