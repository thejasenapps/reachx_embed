import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/helper/widgets/flagWavingGif.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/presentation/mentoring/booked/bookedViewModel.dart';
import 'package:reachx_embed/presentation/commonWidgets/topicCard.dart';
import 'package:reachx_embed/presentation/mentoring/expertDetail/expertDetailScreen.dart';
import 'package:reachx_embed/presentation/mentoring/expertDetail/expertDetailViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/expert_registration/expertRegistrationViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/homeScreen/homeScreenViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/topic_List/topicListViewModel.dart';

class TopicListFilesWidget extends StatefulWidget {
  final TopicListViewModel topicListViewModel;

  String searchItem;

  TopicListFilesWidget({super.key, required this.topicListViewModel, required this.searchItem});

  @override
  State<TopicListFilesWidget> createState() => _TopicListFilesWidgetState();
}

class _TopicListFilesWidgetState extends State<TopicListFilesWidget> {

  ExpertRegistrationViewModel expertRegistrationViewModel = getIt();
  ExpertDetailViewModel expertDetailViewModel = getIt();
  BookedViewModel bookedViewModel = getIt();
  HomeScreenViewModel homeScreenViewModel = getIt();

  ScrollController scrollController = ScrollController();

  bool isVisible = true;


  @override
  void initState() {
    super.initState();
    widget.topicListViewModel.fetchTopicList(search: widget.searchItem ?? ''); // Fetch initial expert list.
    scrollController.addListener(() {
      if(scrollController.offset == 0) {
        if(!isVisible) {
          makeTitleInvisible(true);
        }
      } else {
        if(isVisible) {
          makeTitleInvisible(false);
        }
      }
    });

    ever(expertRegistrationViewModel.saveResult, (bool isSaved) {
      if(mounted) {
        if(isSaved) {
          widget.topicListViewModel.fetchTopicList();
          setState(() {
          });
        }
      }
    });

    ever(bookedViewModel.isRated, (bool isTrue) {
      if(mounted) {
        widget.topicListViewModel.fetchTopicList();
        setState(() {
        });
      }
    });
  }

  void makeTitleInvisible(bool value) {
    setState(() {
      isVisible = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    final aspectRatio = MediaQuery.of(context).size.aspectRatio;

    return Column(
      children: [
        const SizedBox(height: 10,),
        Obx(() {
          if (widget.topicListViewModel.isLoading.value) {
            return const Expanded(child: Center(child: FlagWavingGif()));
          } else if(widget.topicListViewModel.topicList!.topics.isEmpty) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Visibility(
                    visible: widget.topicListViewModel.query.isNotEmpty,
                    child: SizedBox(
                      height: 400,
                      child: StreamBuilder(
                          stream: widget.topicListViewModel.searchGenAIGenerator.responseStream,
                          builder: (context, snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 198),
                                child: SizedBox(
                                  width: 200,
                                  child: LinearProgressIndicator(
                                    backgroundColor: HexColor(mainColor),
                                    color: HexColor(specialColor),
                                  ),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  snapshot.data ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: HexColor(lightBlue)
                                  ),
                                ),
                              );
                            }
                          }
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            final topicList = widget.topicListViewModel.topicList!;
            return Expanded(
              child: Column(
                children: [
                  Visibility(
                    visible: widget.topicListViewModel.query.isNotEmpty,
                    child: SizedBox(
                      height: 36/aspectRatio,
                      child: StreamBuilder(
                          stream: widget.topicListViewModel.searchGenAIGenerator.responseStream,
                          builder: (context, snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 17/aspectRatio),
                                child: SizedBox(
                                  width: 250,
                                  child: LinearProgressIndicator(
                                    backgroundColor: HexColor(mainColor),
                                    color: HexColor(specialColor),
                                  ),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  snapshot.data ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: HexColor(lightBlue)
                                  ),
                                ),
                              );
                            }
                          }
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: topicList.topics.length,
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        final topic = topicList.topics[index];
                        return GestureDetector(
                            onTap: () {

                              Map<String, dynamic> arguments = {
                                "uniqueId": topic.expertId,
                                "topic": topic,
                                "userId": widget.topicListViewModel.userId ?? ''
                              };

                              Get.toNamed(
                                ExpertDetailScreen.route, // Navigate to expert detail screen.
                                arguments: arguments,
                                id: NavIds.home,
                              );
                            },
                            child: TopicCard(topicEntity: topic,topicListViewModel: widget.topicListViewModel,)
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ],
    );
  }
}
