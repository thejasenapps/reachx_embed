import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/core/helper/widgets/globalSnackBar.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/momentEntity.dart';
import 'package:reachx_embed/domain/entities/sessionEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/domain/entities/viewCountEntity.dart';
import 'package:reachx_embed/domain/expertDetail/expertDetailUsecase.dart';
import 'package:reachx_embed/presentation/commonWidgets/simpleDialogBoxWidget.dart';
import 'package:reachx_embed/presentation/mentoring/booked/bookedViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/sessionDetail/SessionDetailScreen.dart';

class ExpertDetailViewModel extends GetxController {

  BookedViewModel bookedViewModel = getIt();

  final ExpertDetailUsecase _expertDetailUsecase = ExpertDetailUsecase();
  final AudioPlayer audioPlayer = AudioPlayer();

  List<TopicEntity> topicEntity = [];
  TopicEntity? passion;
  SessionEntity? sessionEntity;
  String currentAudio = '';
  String? userId;
  MomentsEntity? momentsEntity;

  Rxn<ExpertEntity> expertEntity = Rxn<ExpertEntity>();
  RxBool isLoading = false.obs;
  RxBool isTopicLoading = true.obs;
  RxBool isSessionLoading = true.obs;
  RxBool isPlaying = false.obs;
  RxBool isMomentsLoading = false.obs;

  // Fetches expert details by ID
  void fetchExpertDetail(String expertId) async {
    Future.microtask(() => isLoading.value = true);
    topicEntity = [];
    passion = null;
    userId = userId ?? await FirebaseAuthentication().getFirebaseUid();
    final ExpertEntity fetchedData = await _expertDetailUsecase.fetchExpertDetails(expertId);
    expertEntity.value = fetchedData;
    List topics = expertEntity.value!.topics!;

    for(var one in topics) {
      TopicEntity topic = await _expertDetailUsecase.fetchTopic(one);
      if(topic.skillType == "professional") {
        topicEntity.add(topic);
      } else {
        passion = topic;
      }
    }

    isLoading.value = false;
  }

  void fetchSessionDetail(String uniqueId) async {
    Future.microtask(() => isSessionLoading.value = true);
    sessionEntity = await _expertDetailUsecase.fetchSessionDetail(uniqueId);
    isSessionLoading.value = false;
  }

  Future<void> checkForGroupBooking(BuildContext context, {String session = "videoMeet", TopicEntity? topic, SessionEntity? sessionDetail}) async {
    if(bookedViewModel.combinedEntity != null) {
      if (bookedViewModel.combinedEntity == null || topic!.sessionType != "Group") {
        sessionSwitch(
          context,
          session: session,
          topic: topic,
          sessionDetail: sessionDetail,
        );
        return;
      }



      final alreadyBooked = bookedViewModel.combinedEntity!.any(
              (booking) => booking.topicId == topic.topicId && compareDates(booking.start, sessionDetail!.dateTime!)
      );


      if (alreadyBooked) {
        showAppSnackBar("Already booked this session");
      } else {
        sessionSwitch(
          context,
          session: session,
          topic: topic,
          sessionDetail: sessionDetail,
        );
      }
    }
  }


  void sessionSwitch(BuildContext context, {String session = "videoMeet", TopicEntity? topic, SessionEntity? sessionDetail}) async {
    final expert = expertEntity.value!;
    Map<String, dynamic> bookingDetails;

    switch (session) {
      case "videoMeet":
        bookingDetails = {
          "name": topic!.name,
          "topicId": topic.topicId,
          "expertName": expert.name,
          "expertId": topic.expertId,
          "description": topic.description,
          "rate": topic.topicRate,
          "currencySymbol": topic.currencySymbol,
          "minutes": expert.minutes,
          "sessionId": topic.sessionId,
          "session": "online",
          "sessionType": "oneToOne",
          "meetingUrl": sessionDetail!.link,
          "eventId": sessionDetail.eventId
        };
        break;
      case "onsiteMeet":
        bookingDetails = {
          "name": topic!.name,
          "topicId": topic.topicId,
          "expertName": expert.name,
          "expertId": topic.expertId,
          "description": topic.description,
          "rate": topic.topicRate,
          "currencySymbol": topic.currencySymbol,
          "minutes": expert.minutes,
          "sessionId": topic.sessionId,
          "location": sessionEntity!.location,
          "session": "onsite",
          "sessionType" : "oneToOne",
          "eventId": sessionDetail!.eventId
        };
        break;
      case "webinar":
        bookingDetails = {
          "name": topic!.name,
          "topicId": topic.topicId,
          "expertName": expert.name,
          "expertId": topic.expertId,
          "description": topic.description,
          "rate": topic.topicRate,
          "currencySymbol": topic.currencySymbol,
          "minutes": expert.minutes,
          "sessionId": topic.sessionId,
          "session": "online",
          "sessionType": "group",
          "meetingUrl": topic.meetingUrl,
          "dateTime": sessionDetail!.dateTime,
          "selectedHours": sessionDetail.selectedHours,
          "groupSlotLeft": sessionDetail.groupSlotLeft
        };
        break;
      case "seminar":
        bookingDetails = {
          "name": topic!.name,
          "topicId": topic.topicId,
          "expertName": expert.name,
          "expertId": topic.expertId,
          "description": topic.description,
          "rate": topic.topicRate,
          "currencySymbol": topic.currencySymbol,
          "minutes": expert.minutes,
          "sessionId": topic.sessionId,
          "session": "onsite",
          "sessionType": "group",
          "location": sessionDetail!.location,
          "dateTime": sessionDetail.dateTime,
          "selectedHours": sessionDetail.selectedHours,
          "groupSlotLeft": sessionDetail.groupSlotLeft
        };
        break;
      case "request":
        bookingDetails = {};
        break;
      default:
        bookingDetails = {
          "name": "not available",
          "topicId": "not available",
          "expertName": "not available",
          "expertId": "not available",
          "description": "not available",
          "location": "unknown",
          "rate": 0,
          "minutes": 60,
          "sessionType": session
        };
    }

    if(session != "request") {
      Get.toNamed(
        SessionDetailScreen.route,
        arguments: bookingDetails,
        id: NavIds.home,
      );
    } else {
      bool result = await _expertDetailUsecase.sendRequest(topic!.expertId!, topic.expertName!);

      if(!result) {
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text("request sent"))
        );
      } else {
        showDialog(
            context: context,
            builder: (context) => const SimpleDialogBoxWidget(label: "Request sent and we ll notify you when he is available")
        );
      }
    }
  }

  Future<void> getTreeDetails(String topicId) async {
    isMomentsLoading.value = true;

    Results result = await _expertDetailUsecase.getMoments(topicId);

    if (result is SuccessState) {
      List results = result.value;

      momentsEntity = results[0] as MomentsEntity;

      momentsEntity!.moments.sort((a, b) => a.date.compareTo(b.date));
    }

    isMomentsLoading.value = false;
  }


  /// Plays an audio file URL if available, or pauses if it's already playing.
  Future<bool> playAudio(String audioFile) async {
    try {
      if (currentAudio == audioFile && isPlaying.value) {
        await pauseAudio();
        return false;
      }

      await audioPlayer.stop();
      isPlaying.value = false;

      if (audioFile.isNotEmpty) {
        await audioPlayer.setUrl(audioFile);
        audioPlayer.play();

        isPlaying.value = true;
        currentAudio = audioFile;

        audioPlayer.playerStateStream.listen((playerState) {
          if (playerState.processingState == ProcessingState.completed) {
            isPlaying.value = false;
            currentAudio = '';
          }
        });

        return true;
      } else {
        print("file not found : $audioFile");
        return false;
      }
    } catch (e) {
      print(e);
      isPlaying.value = false;
      currentAudio = '';
      return false;
    }
  }

  /// Pauses the currently playing audio file.
  Future<void> pauseAudio() async {
    try {
      await audioPlayer.pause();
      isPlaying.value = false;
      currentAudio = '';
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }

  /// Reports an expert. If the user is not logged in, prompts for login.
  void reportUser(BuildContext context, String expertId) async {
    String? userId = await FirebaseAuthentication().getFirebaseUid();

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have to log in first")),
      );
    } else {
      Results results = await _expertDetailUsecase.reportExpert(expertId);

      if (results is SuccessState) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("The person have been reported")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error in reporting")),
        );
      }
    }
  }

  /// Retrieves and caches the current Firebase user ID.
  Future<void> initialTasks(String expertId, String topicId) async {
    userId = await FirebaseAuthentication().getFirebaseUid();

    saveProfileViewCount(expertId, topicId);

  }


  Future<void> saveProfileViewCount(String expertId, String topicId) async {
    if(expertId != userId) {
      ViewCountEntity viewCountEntity = ViewCountEntity(
          expertId: expertId,
          timestamp: DateTime.now().toString(),
          topicId: topicId
      );
      _expertDetailUsecase.saveProfileViewCount(viewCountEntity);
    }
  }


  bool compareDates(String date1, String date2) {
    final d1 = DateTime.parse(date1);
    final d2 = DateTime.parse(date2);

    return d1.year == d2.year &&
        d1.month == d2.month &&
        d1.day == d2.day;
  }

}
