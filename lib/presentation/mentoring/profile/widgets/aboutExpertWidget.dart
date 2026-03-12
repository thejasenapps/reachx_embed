import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistration.dart';
class AboutExpertWidget extends StatefulWidget {
  final ExpertEntity expertEntity;

  const AboutExpertWidget({super.key, required this.expertEntity});

  @override
  State<AboutExpertWidget> createState() => _AboutExpertWidgetState();
}

class _AboutExpertWidgetState extends State<AboutExpertWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "About Me",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),
            ),
            IconButton(
                onPressed: () {
                  if(mounted) {
                    Get.toNamed(
                      ExpertRegistration.route,
                      arguments: {
                        "isRegistration": false,
                      },
                      id: NavIds.home,
                    );
                  }
                },
                icon: Icon(
                  Icons.edit,
                  size: 25,
                  color: HexColor(secondaryTextColor),
                )
            )
          ],
        ),
        Text(
          widget.expertEntity.intro,
          style: TextStyle(
              fontSize: 15,
              color: HexColor(secondaryTextColor)
          ),
        ),
        const SizedBox(height: 10),
        Row(
          spacing: 5,
          children: [
            Icon(
              Iconsax.location,
              size: 12,
              color: HexColor(buttonColor),
            ),
            Expanded(
              child: Text(
                "From ${widget.expertEntity.location.isEmpty ? "'Not-Mentioned'" : widget.expertEntity.location}",
                style: TextStyle(
                    fontSize: 12,
                    color: HexColor(secondaryTextColor)
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Row(
          spacing: 5,
          children: [
            Icon(
              Iconsax.box,
              size: 12,
              color: HexColor(buttonColor),
            ),
            Text(
              "Achievements:",
              style: TextStyle(
                  fontSize: 12,
                  color: HexColor(secondaryTextColor)
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:  widget.expertEntity.achievements.isNotEmpty
              ? SizedBox(
            height: widget.expertEntity.achievements.length * 20,
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.expertEntity.achievements.length,
                itemBuilder: (context, index) {
                  return Text(
                    widget.expertEntity.achievements[index],
                    style: TextStyle(
                        fontSize: 12,
                        color: HexColor(lightBlue)
                    ),
                  );
                }
            ),
          )
              :  Text(
            "Not-Given",
            style: TextStyle(
                color: HexColor(lightBlue)
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          spacing: 5,
          children: [
            Icon(
              Iconsax.language_circle,
              size: 12,
              color: HexColor(buttonColor),
            ),
            Text(
              "Languages:",
              style: TextStyle(
                  fontSize: 12,
                  color: HexColor(secondaryTextColor)
              ),
            ),
            widget.expertEntity.languages.isNotEmpty
                ?   Expanded(
              child: SizedBox(
                height: 15,
                child: ListView.builder(
                    itemCount: widget.expertEntity.languages.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return RichText(
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: widget.expertEntity.languages[index],
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: HexColor(lightBlue)
                                    )
                                ),
                                TextSpan(
                                    text: index < widget.expertEntity.languages.length - 1 ? ', ' : '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight : FontWeight.bold,
                                    )
                                )
                              ]
                          )
                      );
                    }
                ),
              ),
            )
                : Text(
              "Not-Given",
              style: TextStyle(
                  fontSize: 12,
                  color: HexColor(secondaryTextColor)
              ),
            )
          ],
        ),
      ],
    );
  }
}
