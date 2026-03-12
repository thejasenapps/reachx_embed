import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/domain/entities/sessionEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customCard.dart';
import 'package:reachx_embed/presentation/mentoring/expertDetail/expertDetailScreen.dart';
import 'package:reachx_embed/presentation/mentoring/expertDetail/expertDetailViewModel.dart';
import 'package:get/get.dart';

class TopicDetailsContainer extends StatefulWidget {
   TopicEntity topicEntity;
   SessionEntity? sessionEntity;
   bool currentTopic;
   ExpertDetailViewModel? expertDetailViewModel;
   bool isUser;
   String booking;

  TopicDetailsContainer({super.key, required this.topicEntity, required this.currentTopic, this.expertDetailViewModel, this.sessionEntity, required this.isUser, required this.booking});

  @override
  State<TopicDetailsContainer> createState() => _TopicDetailsContainerState();
}

class _TopicDetailsContainerState extends State<TopicDetailsContainer> {

  String skill = "professional";
  bool playing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(widget. topicEntity.skillType == "life" || widget.topicEntity.skillType == "lifeSkill") {
      skill = "lifeSkill";
    }

    final width = MediaQuery.of(context).size.width > 500 ? 500 : MediaQuery.of(context).size.width;


    return GestureDetector(
        onTap: () {
          if (!widget.currentTopic && mounted) {
            Map<String, dynamic> arguments = {
              "uniqueId": widget.topicEntity.expertId,
              "topic": widget.topicEntity,
              "userId": widget.expertDetailViewModel!.userId ?? ''
            };

            Get.offNamed(
              ExpertDetailScreen.route,
              arguments: arguments,
              id: NavIds.home,
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(width: 1, color: HexColor(containerBorderColor))
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  widget.currentTopic ? "About this session" : widget.topicEntity.name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: HexColor(black)
                  ),
                ),
                if(widget.currentTopic)
                  Text(
                    widget.topicEntity.description,
                    style: TextStyle(
                        fontSize: 15,
                        color: HexColor(secondaryTextColor)
                    ),
                  ),
                Row(
                  spacing: 10,
                  children: [
                    GestureDetector(
                        onTap: () async {
                          if(widget.topicEntity.audio == null || widget.topicEntity.audio == '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("No audio available"))
                            );
                          } else if(!playing) {
                            widget.expertDetailViewModel!.playAudio(widget.topicEntity.audio!);
                          } else {
                            widget.expertDetailViewModel!.pauseAudio();
                          }
                        },
                        child: CustomCard(
                            content: Obx(() {
                              if(widget.expertDetailViewModel!.isPlaying.value && widget.expertDetailViewModel!.currentAudio == widget.topicEntity.audio) {
                                return Text(
                                  "Playing",
                                  style: TextStyle(
                                      color: HexColor(mainColor)
                                  ),
                                );
                              } else {
                                return Text(
                                  "Hear me",
                                  style: TextStyle(
                                      color: HexColor(lightBlue)
                                  ),
                                );
                              }
                            })
                        )
                    ),
                  ],
                ),
                extraDescription(),
                if (((widget.currentTopic && widget.booking != "upcoming" && widget.sessionEntity!.sessionType.toLowerCase() != "group")
                    || (widget.sessionEntity!.sessionType.toLowerCase() == "group" && DateTime.parse(widget.sessionEntity!.dateTime!).isAfter(DateTime.now()) && widget.currentTopic && widget.booking != "upcoming")) && widget.topicEntity.status == "online") ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.topicEntity.session == "Online" && widget.topicEntity.sessionType == "1:1")
                        customBookButton("Book an Online Meet", "videoMeet"),
                      if (widget.topicEntity.session == "Online" && widget.topicEntity.sessionType == "Group" && widget.sessionEntity!.dateTime != "3000-06-13 12:45:00.000")
                        customBookButton("Book Webinar", "webinar"),
                      if (widget.topicEntity.session == "Onsite" && widget.topicEntity.sessionType == "Group")
                        customBookButton("Book Seminar", "seminar"),
                      if (widget.topicEntity.session == "Onsite" && widget.topicEntity.sessionType == "1:1")
                        customBookButton("Book an Onsite Meet", "onsiteMeet"),
                      if (widget.topicEntity.availability == false)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              spacing: 10,
                              children: [
                                Text(
                                    "Looks like ${widget.topicEntity.expertName}’s calendar is full.\nWant to request a slot?",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: HexColor(secondaryTextColor)
                                    ),
                                  textAlign: TextAlign.center,
                                ),
                                customBookButton("Request Passionate", "request"),
                              ],
                            ),
                          ),
                        ),
                    ],
                  )
                ] else if(widget.currentTopic)...[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        spacing: 10,
                        children: [
                          Text(
                            "Looks like ${widget.topicEntity.expertName}’s calendar is full.\nWant to request a slot?",
                            style: TextStyle(
                                fontSize: 15,
                                color: HexColor(secondaryTextColor)
                            ),
                            textAlign: TextAlign.center,
                          ),
                          customBookButton("Request Slot", "request"),
                        ],
                      ),
                    ),
                  )
                ] else ...[
                  const SizedBox.shrink()
                ]

              ],
            ),
          )
      ),
    );
  }


  Widget extraDescription() {
    return  Row(
      spacing: 5,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            spacing: 5,
            children: [
              const Icon(
                Icons.school,
                color: Colors.yellow,
                size: 13,
              ),
              Text(
                skill,
                style: TextStyle(
                    fontSize: 12,
                    color: HexColor(secondaryTextColor)
                ),
              )
            ],
          ),
        ),
        const SizedBox(width: 20,),
        Text(
          widget.currentTopic ? "${widget.topicEntity.currencySymbol}${widget.topicEntity.topicRate}/hour" : "${widget.topicEntity.session}/ ${widget.topicEntity.sessionType}",
          style: TextStyle(
              fontSize: 11,
              color: HexColor(lightBlue)
          ),
        ),
      ],
    );
  }

  Widget customBookButton(String label, String sessionName) {
    return ElevatedButton(
        onPressed: () {
           if(widget.isUser) {
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(
                   content: Text("You cannot book yourself"),
                 duration: Duration(seconds: 2),
               )
             );
           } else {
             widget.expertDetailViewModel!.checkForGroupBooking(
                 context,
                 session: sessionName,
                 topic: widget.topicEntity,
                 sessionDetail: widget.sessionEntity
             );
           }
          },
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )
          ),
          maximumSize: WidgetStateProperty.all<Size>(
            const Size(250, 40),
          ),
          minimumSize: WidgetStateProperty.all(
              const Size(120, 40)
          ),
          backgroundColor: WidgetStateProperty.all(
              widget.isUser ? Colors.grey : HexColor(lightBlue)
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w900
          ),
        )
    );
  }
}
