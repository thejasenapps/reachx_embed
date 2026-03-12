import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/core/helper/dotGenerator.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customPlaceHolderImage.dart';
import 'package:reachx_embed/presentation/mentoring/topic_List/topicListViewModel.dart';



class TopicCard extends StatefulWidget {

  TopicEntity topicEntity;
  TopicListViewModel topicListViewModel;

  TopicCard({super.key, required this.topicEntity, required this.topicListViewModel});

  @override
  State<TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard> {

  bool playing = false;
  String filteredLocation = '';
  String userId = '';
  String languages = '';

  @override
  void initState() {
    filterLocation();
    filterLanguages();
    if(widget.topicListViewModel.userId != null) {
      userId = widget.topicListViewModel.userId!;
    }
    super.initState();
  }


  void filterLocation() {
    if(widget.topicEntity.session.toLowerCase() == "onsite") {
      filteredLocation = "Offline";
    } else {
      filteredLocation = "Online";
    }

    filteredLocation = widget.topicEntity.sessionType == "Not-Given" ? "Not-Given" : "$filteredLocation/${widget.topicEntity.sessionType}";
  }
  
  
  void filterLanguages() {
    if(widget.topicEntity.languages!.isEmpty) {
      languages = "";
    } else {
      languages = widget.topicEntity.languages!.join(", ");
    }
  }

  @override
  Widget build(BuildContext context) {

    var topic = widget.topicEntity;
    var width = MediaQuery.of(context).size.width > 500 ? 500 :  MediaQuery.of(context).size.width;

    return Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(width: 1, color: HexColor(containerBorderColor))
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: HexColor(containerBorderColor)),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CachedNetworkImage(
                    imageUrl: topic.imageUrl!,
                    width: 60,
                    height: 60,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CustomPlaceHolderImage(),
                  ),
                  errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60)
                      ),
                      child: const Icon(
                        Icons.person, size: 40, color: Colors.grey,
                      )
                  ),
                )
              ),
            ),
            const SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  '#${topic.skillType!.toLowerCase()}skill',
                  style: TextStyle(
                      fontSize: 10,
                      color: HexColor(secondaryTextColor)
                  ),
                ),
                SizedBox(
                  width: width * 0.35,
                  child: Text(
                    topic.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Row(
                  spacing: 10,
                  children: [
                    SizedBox(
                      width: width * 0.22,
                      child: Text(
                        userId != topic.expertId ? topic.expertName! : "${topic.expertName} [You]",
                        style: TextStyle(
                            fontSize: 11,
                            color: HexColor(lightBlue)
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    // DotWidget(size: 3, color: HexColor(secondaryTextColor),),
                    SizedBox(
                      width: 80,
                      child: Text(
                        languages,
                        style: TextStyle(
                            fontSize: 11,
                            color: HexColor(lightBlue)
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    topic.rating == 0
                        ? const Text(
                      "Verified",
                      style: TextStyle(
                          fontSize: 12
                      ),
                    )
                        : Row(
                      children: [
                        StarRating(
                          rating: topic.rating!,
                          size: 12,
                        ),
                        Text(
                            "+${topic.count}",
                          style: const TextStyle(
                              fontSize: 12
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 8,),
                    DotWidget(color: HexColor(secondaryTextColor),size: 3,),
                    const SizedBox(width: 8,),
                    Icon(
                      Icons.meeting_room,
                      size: 12,
                      color: HexColor(mainColor),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text(
                        filteredLocation,
                        style: TextStyle(
                            fontSize: 12,
                            color: HexColor(black)
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  ],
                )
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () async {
                if(topic.audio == null || topic.audio == '') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No audio available"))
                  );
                } else {
                  widget.topicListViewModel.playAudio(topic.audio!);
                }
              },
              icon: Obx(() {
                if(widget.topicListViewModel.isPlaying.value && widget.topicListViewModel.currentAudio == topic.audio) {
                  return const Icon(Icons.pause);
                } else {
                  return const Icon(Icons.play_arrow);
                }
              }),
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.grey[200])
              ),
            ),
          ],
        )
    );
  }
}
