import 'package:flutter/material.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/commonWidgets/editScreen.dart';
import 'package:reachx_embed/presentation/commonWidgets/languageSelector.dart';
import 'package:reachx_embed/presentation/commonWidgets/locationSelector.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistrationViewModel.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/widgets/achievementsTabWidget.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/widgets/paragraphWidget.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/widgets/textWidget.dart';


class BasicDetailWidget extends StatefulWidget {
  ExpertRegistrationViewModel expertRegistrationViewModel;
  bool isRegistration;

  BasicDetailWidget({super.key, required this.expertRegistrationViewModel, required this.isRegistration});

  @override
  State<BasicDetailWidget> createState() => _BasicDetailWidgetState();
}

class _BasicDetailWidgetState extends State<BasicDetailWidget> {

  FocusNode nameFocus = FocusNode();
  FocusNode aboutFocus = FocusNode();


  @override
  void initState() {
    if(widget.expertRegistrationViewModel.expertEntity.name.isNotEmpty) {
      widget.expertRegistrationViewModel.nameController.text = widget.expertRegistrationViewModel.expertEntity.name;
    } else if(widget.expertRegistrationViewModel.expertEntity.intro.isNotEmpty) {
      widget.expertRegistrationViewModel.introController.text = widget.expertRegistrationViewModel.expertEntity.intro;
    } else if(widget.expertRegistrationViewModel.expertEntity.achievements.isNotEmpty) {
      widget.expertRegistrationViewModel.achievements.addAll(
          widget.expertRegistrationViewModel.expertEntity.achievements
      );
    } else if(widget.expertRegistrationViewModel.expertEntity.location.isNotEmpty) {
      widget.expertRegistrationViewModel.locationController.text = widget.expertRegistrationViewModel.expertEntity.location;
    } else if(widget.expertRegistrationViewModel.expertEntity.languages.isNotEmpty) {
      widget.expertRegistrationViewModel.languages.addAll(
        widget.expertRegistrationViewModel.expertEntity.languages
      );
    }

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText("Name"),
        customNameText("Tom Sawyer", widget.expertRegistrationViewModel.nameController),
        const SizedBox(height: 30,),
        customText("About"),
        customParagraphText("Talk about you ", widget.expertRegistrationViewModel.introController),
        const SizedBox(height: 30,),
        customText("Achievements"),
        customAchievementsTab("Personal/ Professional", widget.expertRegistrationViewModel.tileController),
        const SizedBox(height: 20,),
        customText("Location"),
        customLocationText("Location", widget.expertRegistrationViewModel.locationController),
        const SizedBox(height: 30,),
        customText("Language"),
        customLanguageText("Languages"),
      ],
    );
  }


  Widget customText(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold
      ),
    );
  }


  Widget customNameText(String label, TextEditingController controller) {
    return customUnderline(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                widget.expertRegistrationViewModel.expertEntity.name.isNotEmpty
                    ? widget.expertRegistrationViewModel.expertEntity.name
                    : label
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: HexColor(lightBlue),
              ),
            )
          ],
        ),
      ),
          () {
        Map<String, dynamic> arguments = {
          "widget": TextWidget(controller: controller, label: label, focusNode: nameFocus,),
          "function": () => widget.expertRegistrationViewModel.saveBasicRegistration("name"),
          "viewModel": widget.expertRegistrationViewModel,
          "focusNode": nameFocus,
          "title": "Update Name"
        };

        Get.toNamed(
            EditScreen.route,
            id: NavIds.home,
            arguments: arguments
        )!.then((_) {
          setState(() {
          });
        });
      },
    );
  }


  Widget customParagraphText(String label, TextEditingController controller) {

    String text =  widget.expertRegistrationViewModel.expertEntity.intro.isNotEmpty
        ? widget.expertRegistrationViewModel.expertEntity.intro
        : label;

    return customUnderline(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                text
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: HexColor(lightBlue),
              ),
            )
          ],
        ),
      ),
          () {
        Map<String, dynamic> arguments = {
          "widget": ParagraphWidget(controller: controller, label: label, value: text, focusNode: aboutFocus,),
          "function": () => widget.expertRegistrationViewModel.saveBasicRegistration("about"),
          "viewModel": widget.expertRegistrationViewModel,
          "focusNode": aboutFocus,
          "title": "About You"
        };


        Get.toNamed(
            EditScreen.route,
            id: widget.isRegistration ? NavIds.home : NavIds.discover,
            arguments: arguments
        )!.then((_) {
          setState(() {

          });
        });
      },
    );
  }


  Widget customLocationText(String label, TextEditingController controller) {
    return customUnderline(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                  widget.expertRegistrationViewModel.expertEntity.location.isNotEmpty
                      ? widget.expertRegistrationViewModel.expertEntity.location
                      : label,
                maxLines: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: HexColor(lightBlue),
              ),
            )
          ],
        ),
      ),
      () {
        Map<String, dynamic> arguments = {
          "widget": LocationSelectorWidget(viewModel: widget.expertRegistrationViewModel, textController: controller, length: 200,),
          "function": () => widget.expertRegistrationViewModel.saveBasicRegistration("location"),
          "viewModel": widget.expertRegistrationViewModel,
          "location": "Location",
          "title": "Update Location"
        };


        Get.toNamed(
            EditScreen.route,
            id: widget.isRegistration ? NavIds.home : NavIds.discover,
            arguments: arguments
        )!.then((_) {
          setState(() {

          });
        });
      },
    );
  }


  Widget customLanguageText(String label) {
    return customUnderline(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: widget.expertRegistrationViewModel.expertEntity.languages.isNotEmpty
                  ? Wrap(
                spacing: 6.0,
                children: widget.expertRegistrationViewModel.expertEntity.languages
                    .map((language) => Text(language))
                    .toList(),
              )
                  : Text(label),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: HexColor(lightBlue),
              ),
            ),
          ],
        ),
      ),
          () {
        widget.expertRegistrationViewModel.languages.addAll(widget.expertRegistrationViewModel.expertEntity.languages);
      
        Map<String, dynamic> arguments = {
          "widget": LanguageSelectorWidget(viewModel: widget.expertRegistrationViewModel),
          "function": () => widget.expertRegistrationViewModel.saveBasicRegistration("languages"),
          "viewModel": widget.expertRegistrationViewModel,
          "title": "Update Language",
        };

        Get.toNamed(
          EditScreen.route,
          id: widget.isRegistration ? NavIds.home : NavIds.discover,
          arguments: arguments,
        )!.then((_) {
          setState(() {});
        });
      },
    );
  }



  Widget customAchievementsTab(String label, TextEditingController controller) {

    final viewModel = widget.expertRegistrationViewModel;

    return GestureDetector(
      onTap: () {
        if(widget.expertRegistrationViewModel.expertEntity.achievements.isNotEmpty) {
          widget.expertRegistrationViewModel.tiles.clear();
          widget.expertRegistrationViewModel.tiles.addAll(widget.expertRegistrationViewModel.expertEntity.achievements);
        }

        Map<String, dynamic> arguments = {
          "widget": AchievementsTabWidget(expertRegistrationViewModel: widget.expertRegistrationViewModel, controller: controller, label: label),
          "function": () {
            if(controller.text.isNotEmpty) {
              widget.expertRegistrationViewModel.tiles.add(controller.text);

              widget.expertRegistrationViewModel.updateAchievements(controller.text, "add");
            } else {
              Navigator.pop(context);
            }
            controller.clear();
          },
          "viewModel": viewModel,
          "title": "Update Achievements"
        };

        Get.toNamed(
            EditScreen.route,
            id: widget.isRegistration ? NavIds.home : NavIds.discover,
            arguments: arguments
        )!.then((_) {
          setState(() {

          });
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: HexColor(containerBorderColor),
            width: 2
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.expertRegistrationViewModel.expertEntity.achievements.isNotEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.expertRegistrationViewModel.expertEntity.achievements.map((achievement) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: customTile(achievement),
                  );
                }).toList(),
              )
                  : Text(label),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: HexColor(lightBlue),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget customUnderline(Widget widget, VoidCallback function) {
    return GestureDetector(
      onTap: function,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: HexColor(containerBorderColor)
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: widget,
      ),
    );
  }

  Widget customTile(String text) {

    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: HexColor(containerBorderColor)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Iconsax.medal,
            size: 18,
            color: HexColor(lightBlue),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: width * 0.45,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

}
