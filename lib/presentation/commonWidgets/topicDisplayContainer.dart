import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:reachx_embed/assets/fonts/iconsax_icons.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/dateAndTimeConvertors.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/helper/weekSummarizer.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/domain/entities/sessionEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customCard.dart';
import 'package:share_plus/share_plus.dart';

class TopicDisplayContainer extends StatefulWidget {
  Widget elements;
  TopicEntity topic;
  SessionEntity? sessionEntity;
  bool? isProfile;
  bool? isGather;

  TopicDisplayContainer(
      {super.key,
      required this.elements,
      required this.topic,
      this.sessionEntity,
      this.isGather,
      this.isProfile});

  @override
  State<TopicDisplayContainer> createState() => _TopicDisplayContainerState();
}

class _TopicDisplayContainerState extends State<TopicDisplayContainer> {
  final DateAndTimeConvertors _dateAndTimeConvertors = DateAndTimeConvertors();
  final WeekSummarizer _weekSummarizer = WeekSummarizer();

  final AudioCoordinator _audioCoordinator = getIt();

  final AudioPlayer audioPlayer = AudioPlayer();

  bool playing = false;

  Map<String, dynamic>? dateTime;
  String session = '';
  String sessionType = '';
  List<String> weekDays = [];

  @override
  Widget build(BuildContext context) {
    
    if(widget.sessionEntity != null) {
      if (widget.sessionEntity!.session == "Online") {
        session = "Online";
      } else if (widget.sessionEntity!.session == "Onsite") {
        session = "Offline";
      }

      if (widget.sessionEntity!.sessionType == "1:1") {
        sessionType = "1:1";
        weekDays =
            _weekSummarizer.summarizeWeekdays(widget.sessionEntity!.weekdays!, 0);
      } else if (widget.sessionEntity!.sessionType == "Group") {
        sessionType = "Group";
        if (widget.sessionEntity!.dateTime != null) {
          print(widget.sessionEntity!.dateTime);
          dateTime =
              _dateAndTimeConvertors.fromUTC(widget.sessionEntity!.dateTime!);
        }
      }
    }

    dynamic audio;

    if (widget.topic.audio != null) {
      if (widget.topic.audio is XFile) {
        audio = widget.topic.audio.path;
      } else if (widget.topic.audio is String) {
        audio = widget.topic.audio;
      }
    }

    final double width =
        kIsWeb ? 200 : MediaQuery.of(context).size.width * 0.35;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: HexColor(containerBorderColor)),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: width,
                    child: Text(
                      widget.topic.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: HexColor(black),
                          fontSize: 14),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const Spacer(),
                widget.elements
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              widget.topic.description,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
                onTap: () {
                  if (widget.topic.audio == null || widget.topic.audio == '') {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("No audio found"),
                      duration: Duration(seconds: 1),
                    ));
                  } else {
                    _audioCoordinator.playAudio(widget.topic.audio);
                  }
                },
                child: CustomCard(
                    content: widget.topic.audio != null &&
                            widget.topic.audio != ''
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 5,
                            children: [
                              Obx(() {
                                if (_audioCoordinator.isPlaying.value &&
                                    _audioCoordinator.currentAudio == audio) {
                                  return Icon(
                                    Icons.pause,
                                    size: 12,
                                    color: HexColor(mainColor),
                                  );
                                } else {
                                  return Icon(
                                    Icons.play_arrow,
                                    size: 12,
                                    color: HexColor(mainColor),
                                  );
                                }
                              }),
                              Obx(() {
                                if (_audioCoordinator.isPlaying.value &&
                                    _audioCoordinator.currentAudio == audio) {
                                  return Text(
                                    "Pause",
                                    style: TextStyle(
                                        color: HexColor(mainColor),
                                        fontSize: 12),
                                  );
                                } else {
                                  return Text(
                                    "Play",
                                    style: TextStyle(
                                        color: HexColor(lightBlue),
                                        fontSize: 12),
                                  );
                                }
                              }),
                            ],
                          )
                        : Row(
                            spacing: 5,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.microphone_slash_1,
                                color: HexColor(lightBlue),
                                size: 18,
                              ),
                              const Text(
                                "No Audio",
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ))),
            Row(
              spacing: 5,
              children: [
                customTitle("Skill Type: "),
                const Icon(
                  Iconsax.cup,
                  size: 12,
                ),
                Text(
                  widget.topic.skillType ?? "professional",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                customTitle(widget.isGather != null ? "Availability:": "My Availability:"),
                widget.topic.sessionType == "1:1"
                    ? SizedBox(
                        height: 20,
                        width: width * 0.5,
                        child: ListView.builder(
                            itemCount: weekDays.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return customValue("${weekDays[index]} ");
                            }),
                      )
                    : Text(
                        dateTime != null
                            ? "${dateTime!["date"]} at ${dateTime!["time"]}"
                            : "Not-Given",
                        style: TextStyle(
                          color: HexColor(lightBlue),
                          fontSize: 13,
                        ),
                      ),
              ],
            ),
            Row(
              spacing: 5,
              children: [
                customTitle(widget.isGather != null ? "Session fee: " : "My session fee: "),
                customValue(
                    "${widget.topic.currencySymbol}${widget.topic.topicRate}/hour"),
                const Spacer(),
                Icon(
                  Icons.meeting_room,
                  size: 12,
                  color: HexColor(lightBlue),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    widget.topic.session == "Not-Given"
                        ? "Not Given"
                        : "${widget.topic.session}/${widget.topic.sessionType}",
                    style: TextStyle(fontSize: 12, color: HexColor(black)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget customTitle(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 12,
      ),
    );
  }

  Widget customValue(String label) {
    return Text(
      label,
      style: TextStyle(
        color: HexColor(lightBlue),
        fontSize: 13,
      ),
    );
  }
}

class AudioCoordinator extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();

  String currentAudio = '';
  RxBool isPlaying = false.obs;

  // Plays an audio file from a given URL.
  Future<bool> playAudio(dynamic audioFile) async {
    try {
      if (currentAudio == audioFile && isPlaying.value) {
        await pauseAudio();
        return false;
      }

      await audioPlayer.stop();
      isPlaying.value = false;

      if (audioFile is String) {
        await audioPlayer.setUrl(audioFile);
        currentAudio = audioFile;
      } else {
        final bytes = await audioFile.readAsBytes();
        const mimeType = 'audio/aac';

        final uri = Uri.dataFromBytes(bytes, mimeType: mimeType);

        await audioPlayer.setUrl(uri.toString());

        currentAudio = audioFile.path;
      }

      audioPlayer.play();

      isPlaying.value = true;

      audioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          isPlaying.value = false;
          currentAudio = '';
        }
      });

      return true;
    } catch (e) {
      print(e);
      isPlaying.value = false;
      currentAudio = '';
      return false;
    }
  }

  Future<void> pauseAudio() async {
    try {
      await audioPlayer.pause();
      isPlaying.value = false;
      currentAudio = '';
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }
}
