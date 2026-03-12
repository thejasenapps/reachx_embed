import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/global_passion.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/presentation/commonWidgets/backNavigationWidget.dart';
import 'package:reachx_embed/presentation/mentoring/profile/widgets/deletionBox.dart';
import 'package:reachx_embed/presentation/mentoring/profile/widgets/profileDetailWidget.dart';
import 'package:reachx_embed/presentation/commonWidgets/confirmationBox.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistration.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistrationViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/homeScreenViewModel.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/presentation/mentoring/wallet/walletScreen.dart';
import 'dart:io' show Platform;
import 'package:reachx_embed/presentation/mentoring/profile/profileViewModel.dart';




class ProfileExpertDetailsWidget extends StatefulWidget {

  ProfileViewModel profileViewModel;

  ProfileExpertDetailsWidget({super.key, required this.profileViewModel});

  @override
  State<ProfileExpertDetailsWidget> createState() => _ProfileExpertDetailsWidgetState();
}

class _ProfileExpertDetailsWidgetState extends State<ProfileExpertDetailsWidget> {

  HomeScreenViewModel homeScreenViewModel = getIt();
  ExpertRegistrationViewModel expertRegistrationViewModel = getIt();

  final ScrollController scrollController = ScrollController();
  final GlobalKey _profileDetailKey = GlobalKey();


  String statusChange = "offline";
  double imageOpacity = 1.0;

  @override
  void initState() {

    scrollController.addListener(() {
      double offset = scrollController.offset;
      widget.profileViewModel.scrollOffset = offset;
      setState(() {
        imageOpacity = (1 - (offset / 100)).clamp(0.0, 1.0);
      });
    });

    super.initState();

    if(globalExpertEntity.value.status != null) {
      statusChange = globalExpertEntity.value.status!;
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var expert = globalExpertEntity.value;

    return Column(
      children: [
        if(!kIsWeb)
          SizedBox(
            height: Platform.isIOS ? 50: 40,
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: kIsWeb ? 100 : MediaQuery.of(context).size.width * 0.25,
          children: [
            BackNavigationWidget(context: context),
            Text(
              "My Profile",
              style: TextStyle(
                color: HexColor(black),
                fontSize: 16
              ),
            ),
            const SizedBox(width: 40,)
          ],
        ),
        const SizedBox(height: 70,),
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Container(
                    key: _profileDetailKey,
                    decoration: BoxDecoration(
                      color: HexColor(containerColor),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      border: Border.all(
                          color: HexColor(containerBorderColor),
                          width: 2
                      ),
                    ),
                    width: double.infinity,
                    child: ProfileDetailWidget(profileViewModel: widget.profileViewModel, expertEntity: expert, scrollController: scrollController,)
                ),
              ),
              positionedImage(expert.imageFile)
            ],
          ),
        ),
      ],
    );
  }
  
  Widget positionedImage(String imageUrl) {
    return  Positioned(
      left: 0,
      right: 0,
      top: -50, // Adjust this value to move it up or down in the container
      child: Align(
        alignment: Alignment.center,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: imageOpacity,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child:  CachedNetworkImage(
                imageUrl: imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.fill,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    color: HexColor(loadingIndicatorColor),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: HexColor(containerBorderColor)),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60)
                    ),
                    child: const Icon(
                      Icons.person, size: 60, color: Colors.grey,
                    )
                ),
              )
          ),
        ),
      ),
    );
  }
}
