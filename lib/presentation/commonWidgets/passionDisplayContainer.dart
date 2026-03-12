import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/presentation/commonWidgets/customItems/customElevatedButton.dart';
import 'package:reachx_embed/presentation/mentoring/expertDetail/momentsViewScreen.dart';
import 'package:share_plus/share_plus.dart';

class PassionDisplayContainer extends StatefulWidget {
  Widget elements;
  TopicEntity topic;
  bool? isProfile;
  bool? isGather;

  PassionDisplayContainer(
      {super.key,
      required this.elements,
      required this.topic,
      this.isProfile,
      this.isGather,
      });

  @override
  State<PassionDisplayContainer> createState() =>
      _PassionDisplayContainerState();
}

class _PassionDisplayContainerState extends State<PassionDisplayContainer> {
  final AudioPlayer audioPlayer = AudioPlayer();

  bool playing = false;

  Map<String, dynamic>? dateTime;
  String session = '';
  String sessionType = '';
  List<String> weekDays = [];

  @override
  Widget build(BuildContext context) {
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
            if (widget.isProfile != null && widget.isProfile!)
              CustomElevatedButton(
                label: widget.isGather != null ? "Their Journey" : "My Journey",
                onTap: () {
                },
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
