import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/helper/widgets/flagWavingGif.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customElevatedButton.dart';
import 'package:reachx_embed/presentation/mentoring/expertDetail/expertDetailViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/expertDetail/momentsViewScreen.dart';
import 'package:reachx_embed/presentation/mentoring/expertDetail/widgets/topicDetailsContainer.dart';
import 'package:reachx_embed/presentation/mentoring/shareTemplate/shareTemplateScreen.dart';

class DetailContainerWidget extends StatefulWidget {
  ExpertDetailViewModel expertDetailViewModel;
  ExpertEntity expertEntity;
  TopicEntity topicEntity;
  String userId;
  String booking;
  ScrollController scrollController;

  DetailContainerWidget(
      {super.key,
      required this.expertDetailViewModel,
      required this.expertEntity,
      required this.topicEntity,
      required this.userId,
      required this.booking,
      required this.scrollController});

  @override
  State<DetailContainerWidget> createState() => _DetailContainerWidgetState();
}

class _DetailContainerWidgetState extends State<DetailContainerWidget> {
  bool playing = false;

  @override
  void initState() {
    widget.expertDetailViewModel
        .fetchSessionDetail(widget.topicEntity.sessionId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.expertDetailViewModel.isSessionLoading.value) {
        return const Center(
          child: FlagWavingGif(),
        );
      } else {
        return SingleChildScrollView(
          controller: widget.scrollController,
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              const SizedBox(
                height: 80,
              ),
              Text(
                widget.expertEntity.name,
                style: TextStyle(
                  fontSize: 20,
                  color: HexColor(black),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontSize: 15, color: HexColor(secondaryTextColor)),
                      children: [
                        const TextSpan(text: "This session is about "),
                        TextSpan(
                            text: widget.topicEntity.name,
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold))
                      ]),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: aboutExpert(widget.expertEntity),
              ),
              TopicDetailsContainer(
                topicEntity: widget.topicEntity,
                currentTopic: true,
                expertDetailViewModel: widget.expertDetailViewModel,
                sessionEntity: widget.expertDetailViewModel.sessionEntity,
                isUser: widget.topicEntity.expertId == widget.userId,
                booking: widget.booking,
              ),
              widget.expertDetailViewModel.topicEntity.length > 1
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Other sessions:",
                                style: TextStyle(
                                    color: HexColor(black),
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        SizedBox(
                          height: 200 *
                                  (widget.expertDetailViewModel.topicEntity
                                          .length -
                                      1) +
                              (MediaQuery.of(context).size.height / 700),
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget
                                  .expertDetailViewModel.topicEntity.length,
                              itemBuilder: ((context, index) {
                                TopicEntity topic = widget
                                    .expertDetailViewModel.topicEntity[index];

                                if (widget.topicEntity.topicId !=
                                        topic.topicId &&
                                    topic.skillType == "professional") {
                                  return TopicDetailsContainer(
                                    topicEntity: topic,
                                    currentTopic: false,
                                    isUser:
                                        widget.expertDetailViewModel.userId ==
                                            widget.topicEntity.expertId,
                                    expertDetailViewModel:
                                        widget.expertDetailViewModel,
                                    booking: widget.booking,
                                    sessionEntity: widget
                                        .expertDetailViewModel.sessionEntity,
                                  );
                                }
                                return const SizedBox.shrink();
                              })),
                        )
                      ],
                    )
                  : const SizedBox(
                      height: 100,
                    )
            ],
          ),
        );
      }
    });
  }

  Widget aboutExpert(ExpertEntity expertEntity) {
    String firstName = widget.expertEntity.name.split(" ")[0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 3,
      children: [
        Text(
          "About $firstName",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          expertEntity.intro,
          style: TextStyle(fontSize: 15, color: HexColor(secondaryTextColor)),
          textAlign: TextAlign.left,
        ),
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
                "From ${expertEntity.location}",
                style: TextStyle(
                    fontSize: 12, color: HexColor(secondaryTextColor)),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            )
          ],
        ),
        Row(
          spacing: 5,
          children: [
            Icon(
              Iconsax.box,
              size: 12,
              color: HexColor(buttonColor),
            ),
            Text(
              "Experience:",
              style:
                  TextStyle(fontSize: 12, color: HexColor(secondaryTextColor)),
            ),
            if (expertEntity.achievements.isNotEmpty)
              Expanded(
                child: SizedBox(
                  height: 20,
                  child: ListView.builder(
                      itemCount: expertEntity.achievements.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Text(
                          "${expertEntity.achievements[index]} ",
                          style: TextStyle(
                              fontSize: 12, color: HexColor(lightBlue)),
                        );
                      }),
                ),
              )
          ],
        ),
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
              style:
                  TextStyle(fontSize: 12, color: HexColor(secondaryTextColor)),
            ),
            if (expertEntity.languages.isNotEmpty)
              Expanded(
                child: SizedBox(
                  height: 15,
                  child: ListView.builder(
                      itemCount: expertEntity.languages.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: expertEntity.languages[index],
                              style: TextStyle(
                                  fontSize: 12, color: HexColor(lightBlue))),
                          TextSpan(
                              text: index < expertEntity.languages.length - 1
                                  ? ', '
                                  : '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ))
                        ]));
                      }),
                ),
              )
          ],
        ),
        if (widget.expertDetailViewModel.passion != null &&
            widget.expertDetailViewModel.passion!.momentsIds!.isNotEmpty)
          Center(
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: HexColor(containerBorderColor)),
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                        children: [
                          const TextSpan(
                            text: "This expert is passionate about\n",
                          ),
                          TextSpan(
                            text: widget.expertDetailViewModel.passion!.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    CustomElevatedButton(
                        label: "Check out their journey",
                        special: true,
                        onTap: () {
                          Get.toNamed(MomentsViewScreen.route,
                              arguments: {
                                "expertDetailViewModel":
                                    widget.expertDetailViewModel,
                                "topicId": widget
                                    .expertDetailViewModel.passion!.topicId,
                                "topicName":
                                    widget.expertDetailViewModel.passion!.name,
                                "expertName": widget.expertDetailViewModel
                                    .expertEntity.value!.name
                              },
                              id: NavIds.home);
                        }),
                  ],
                )),
          ),
        const SizedBox(
          height: 10,
        ),
        if (widget.expertDetailViewModel.sessionEntity!.sessionType
                    .toLowerCase() !=
                "group" ||
            widget.expertDetailViewModel.sessionEntity!.dateTime == null ||
            DateTime.parse(
                    widget.expertDetailViewModel.sessionEntity!.dateTime!)
                .isAfter(DateTime.now())
        )
          InkWell(
            onTap: () {
              Get.toNamed(ShareTemplateScreen.route,
                  id: NavIds.home,
                  arguments: {
                    "topicEntity": widget.topicEntity,
                    "sessionEntity": widget.expertDetailViewModel.sessionEntity,
                  });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                spacing: 10,
                children: [
                  Text(
                    "Share Profile:",
                    style: TextStyle(
                        fontSize: 15, color: HexColor(secondaryTextColor)),
                  ),
                  Icon(
                    Icons.share,
                    size: 16,
                    color: HexColor(lightBlue),
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }
}
