import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/helper/findPlatform.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/presentation/commonWidgets/confirmationBox.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistrationViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/widgets/basicDetailWidget.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/widgets/imageUploadWidget.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/homeScreen.dart';
import 'package:reachx_embed/presentation/commonWidgets/backNavigationWidget.dart';
import 'package:reachx_embed/presentation/commonWidgets/emptyUserWidget.dart';
import 'package:skeletonizer/skeletonizer.dart';


class ExpertRegistration extends StatefulWidget {
  static const route = '/ExpertRegistration'; // Route name for navigation.

  Map<String, dynamic> arguments;

  ExpertRegistration({
    super.key,
    required this.arguments
  });

  @override
  State<ExpertRegistration> createState() => _ExpertRegistrationState();
}

class _ExpertRegistrationState extends State<ExpertRegistration> {
  final ExpertRegistrationViewModel expertRegistrationViewModel = getIt();

  @override
  void initState() {
    super.initState();
    expertRegistrationViewModel.fetchExpertDetails();
    BackButtonInterceptor.add(interceptor); // Adds a back-button interceptor.
  }

  bool interceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if(expertRegistrationViewModel.topics.isNotEmpty) {
      showDialog(
          context: context,
          builder: (context)  {
            return ConfirmationBoxWidget(
                functionality: () {
                  Navigator.pop(context);
                  Get.offNamed(
                    HomeScreen.route,
                    id: NavIds.home
                  );
                },
                label: "Are your sure you want to go back?\n All data will be lost"
            );
          }
      );
      return false;
    }
    Navigator.pop(context);
    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(interceptor); // Removes the back-button interceptor.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final containerHeight = findPlatform();

    return SafeArea(
      child: Scaffold(
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
              backgroundColor: Colors.white,
              leading: BackNavigationWidget(context: context),
              title: Text(
                widget.arguments["isRegistration"] ? "Expert Registration" : "Profile Edit",
                style: TextStyle(
                  color: HexColor(black),
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Obx(() {
                  if(!widget.arguments["isRegistration"] && expertRegistrationViewModel.expertEntity.uniqueId.isEmpty && !expertRegistrationViewModel.isLoading.value) {
                    return const EmptyUserWidget(isProfile: false,);
                  } else {
                    return Skeletonizer(
                        enabled: expertRegistrationViewModel.isLoading.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 30,
                          children: [
                            Center(child: ImageUploadWidget(expertRegistrationViewModel: expertRegistrationViewModel)),
                            BasicDetailWidget(expertRegistrationViewModel: expertRegistrationViewModel, isRegistration: widget.arguments["isRegistration"],),
                          ],
                        )
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
