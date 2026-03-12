import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistrationViewModel.dart';

class AchievementsTabWidget extends StatefulWidget {
  ExpertRegistrationViewModel expertRegistrationViewModel;
  TextEditingController controller;
  String label;

  AchievementsTabWidget({
    super.key,
    required this.expertRegistrationViewModel,
    required this.controller,
    required this.label
  });

  @override
  State<AchievementsTabWidget> createState() => _AchievementsTabWidgetState();
}

class _AchievementsTabWidgetState extends State<AchievementsTabWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.label,
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: HexColor(containerBorderColor),
                )
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: HexColor(containerBorderColor),
                )
            ),
          ),
          onTapOutside: (value) {
            if(widget.controller.text.isNotEmpty) {
              widget.expertRegistrationViewModel.tiles.add(widget.controller.text);

              widget.expertRegistrationViewModel.updateAchievements(widget.controller.text, "add");
            }
            widget.controller.clear();
          },
          onSubmitted: (value) {
            if(widget.expertRegistrationViewModel.tileController.text.isNotEmpty) {
              widget.expertRegistrationViewModel.tiles.add(widget.expertRegistrationViewModel.tileController.text);

              widget.expertRegistrationViewModel.updateAchievements(value, "add");
            }
            widget.controller.clear();
          },
        ),
        Obx(() {
          if(widget.expertRegistrationViewModel.tiles.isNotEmpty) {
            return Wrap(
              children: widget.expertRegistrationViewModel.tiles.map((tile) {
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: HexColor(containerBorderColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 35,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  widget.expertRegistrationViewModel.tiles.remove(tile);
                                  widget.expertRegistrationViewModel.updateAchievements(tile, "remove");
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  size: 14,
                                )
                            ),
                            Text(
                              tile,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    )
                );
              }).toList(),
            );
          } else {
            return const SizedBox.shrink();
          }
        })

      ],
    );
  }
}
