import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/constants/enums.dart';
import 'package:reachx_embed/core/constants/navId.dart';
import 'package:reachx_embed/core/global_passion.dart';
import 'package:reachx_embed/core/global_variables.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/core/helper/widgets/globalSnackBar.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/subscriptionMailEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/domain/entities/userEntity.dart';
import 'package:reachx_embed/domain/profile/profileUsecase.dart';
import 'package:reachx_embed/presentation/commonWidgets/susbcriptionDialogBoxWidget.dart';
import 'package:reachx_embed/presentation/mentoring/booked/bookedViewModel.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/signUpScreen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ProfileViewModel extends GetxController {

  final ProfileUsecase profileUsecase = ProfileUsecase();
  final BookedViewModel bookedViewModel = getIt();
  final AudioPlayer audioPlayer = AudioPlayer();
  final GlobalKey testKey = GlobalKey();

  late BuildContext context;

  RxBool isLoading = false.obs;
  RxBool isTopicLoading = false.obs;
  RxBool isPlaying = false.obs;
  RxBool isDeleting = false.obs;
  RxBool result = false.obs;
  RxString statusChange = "offline".obs;
  RxBool expert = false.obs;

  var currentAudio;
  double? scrollOffset;


  UserEntity userEntity = UserEntity(name: '', phoneNo: '', email: '', subscriptionStatus: 'beginner');
  TopicEntity topicEntity = TopicEntity(name: '', description: '', session: '', sessionType: '', topicRate: 0, sessionId: '', availability: false, topicId:  '');

  // Fetch profile details for either an expert or user.
  void fetchProfileDetails() async {
    isLoading.value = true;
    globalExpertEntity.value = await profileUsecase.fetchExpertProfile();

    final expertEntity = globalExpertEntity.value;

    if(globalExpertEntity.value.name.isNotEmpty
        && globalExpertEntity.value.intro.isNotEmpty
        && globalExpertEntity.value.achievements.isNotEmpty
        && globalExpertEntity.value.location.isNotEmpty) {
      isExpert.value = true;
    }
    // If expert profile is not found, fetch user profile.
    if (globalExpertEntity.value.topics!.isEmpty) {
      expertReg = false;
      expert.value = false;
      globalTopics.clear();
    } else {
      status = globalExpertEntity.value.status!;
      expertReg = true;
      profileUsecase.saveOnline("online", status);
      expert.value = true;
      isExpert.value = true;
      globalUserId.value = globalExpertEntity.value.uniqueId;
      fetchTopicDetails();
    }
    isLoading.value = false;
  }

  // Fetches detailed information for each topic associated with the expert
  void fetchTopicDetails() async {
    isTopicLoading.value = true;
    globalTopics.clear();
    globalSessions.clear();
    globalPassions.clear();
    topicList = {};

    final futures = globalExpertEntity.value.topics!.map((id) async {
      final topic = await profileUsecase.fetchTopicDetail(id);

      final session = await profileUsecase.fetchSessionDetail(topic.sessionId);

      if(topic.skillType!.toLowerCase() == "professional") {
        globalTopics.add(topic);
        globalSessions.add(session);
      } else {
        globalPassions.add(topic);
      }

      topicList.add([topic.topicId, topic.name]);
    });

    await Future.wait(futures);

    isTopicLoading.value = false;
  }

  void logOut() async {
    result.value = await profileUsecase.logOut();

    if(result.value) {
      fetchProfileDetails();
      bookedViewModel.latestBooking.clear();
      expert.value = false;
      isExpert.value = false;
      signal.value = false;


      globalExpertEntity.value = ExpertEntity(
        uniqueId: '',
        name: '',
        minutes: 60,
        topics: [],
        intro: '',
        location: "unknown",
        experience: 0,
        languages: [],
        achievements: [],
        imageFile: ''
      );

      globalTopics.clear();
      globalPassions.clear();
      globalSessions.clear();
      globalUserId.value = '';
      globalStreakCount = (-1).obs;
      globalSubscriptionEntity.clear();
      globalSubscriptionStatus.value = SubscriptionStatus.beginner;
    }

  }

  // Check internet connectivity.
  Future<bool> isOnline() async {
    return profileUsecase.isOnline();
  }

// Updates expert's availability status (online/offline).
  Future<void> assignStatus(BuildContext context, String statusUpdate) async {
    profileUsecase.assignStatus(statusUpdate);
    statusChange.value = statusUpdate == "offline" ? "offline" : "online";
  }

  // Plays audio from either a local file or a remote URL. If same audio is playing, it toggles pause.
  Future<bool> playAudio(var audio) async {
    try {
      if (audio != null) {
        if (currentAudio == audio && isPlaying.value) {
          await pauseAudio();
          return false;
        }

        await audioPlayer.stop();
        isPlaying.value = false;

        if (audio is File) {
          await audioPlayer.setFilePath(audio.path);
        } else if (audio is String) {
          await audioPlayer.setUrl(audio);
        }

        audioPlayer.play();
        isPlaying.value = true;
        currentAudio = audio;

        // Reset state when audio completes
        audioPlayer.playerStateStream.listen((playerState) {
          if (playerState.processingState == ProcessingState.completed) {
            isPlaying.value = false;
            currentAudio = '';
          }
        });

        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      isPlaying.value = false;
      currentAudio = '';
      return false;
    }
  }

  // Pauses currently playing audio and clears the state.
  Future<void> pauseAudio() async {
    try {
      await audioPlayer.pause();
      isPlaying.value = false;
      currentAudio = '';
    } catch (e) {
      debugPrint("Error pausing audio: $e");
    }
  }

  // Checks if the expert has upcoming meetings before allowing profile deletion.
  void checkMeetings(BuildContext context) async {
    bool response = await profileUsecase.checkMeetings();

    if (response) {
      isDeleting.value = true;
      bool results = await deleteExperts();
      isDeleting.value = false;
      Navigator.pop(context);

      if (results) {
        fetchProfileDetails();
        bookedViewModel.latestBooking.clear();
        expert.value = false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error in deletion: Bookings persists"))
      );
    }
  }

  // Deletes a user account and resets profile-related data.
  void userDelete(BuildContext context) async {
    isDeleting.value = true;

    bool result = await profileUsecase.deleteUser();

    isDeleting.value = false;
    Navigator.pop(context);

    if (result) {
      fetchProfileDetails();
      bookedViewModel.latestBooking.clear();
      expert.value = false;
    }
  }

  // Constructs a deletion map of topics, sessions, and calendar events for account cleanup.
  Future<bool> deleteExperts() {
    Map<String, List> deleteMap = {};

    if (globalExpertEntity.value.topics!.isNotEmpty) {
      deleteMap["topics"] = globalExpertEntity.value.topics!.map((topicId) => topicId as String).toList();
      deleteMap["sessions"] = globalTopics.map((topic) => topic.sessionId).toList();
      deleteMap["cal"] = globalTopics.map((topic) {
        if (topic.sessionType == "1:1") {
          return topic.topicId;
        }
      }).toList();
    }

    return profileUsecase.deleteUser(deleteMap: deleteMap);
  }

  // Shares expert topic content along with an image (web vs mobile behavior handled separately).
  void sharingTopics(String expertName, String url, String imageUrl) async {
    if (kIsWeb) {
      SharePlus.instance.share(
          ShareParams(text: "Check out $expertName's passions: $url")
      );
    } else {
      final image = await http.get(Uri.parse(imageUrl));
      final bytes = image.bodyBytes;

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/shared_image.jpg').create();
      await file.writeAsBytes(bytes);

      final shareText = "Check out $expertName's passions: $url";

      final params = ShareParams(
          text: shareText,
          files: [XFile('lib/assets/images/reachX_icon.png')]
      );

      final result = await SharePlus.instance.share(params);
      debugPrint(result.toString());
    }
  }

  // Attempts to open a URL using the external browser.
  Future<bool> openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    } else {
      return false;
    }
  }

  Future<void> getPhoneNo() async {
    officialPhone = await profileUsecase.getOfficialPhone();
  }

  Future<void> openWhatsApp(String type) async {
    final String phone = officialPhone.isNotEmpty ? officialPhone : "916238637381";
    late final String message;
    if(type == "support") {
      message = "Hello, ReachX Support";
    }
    final Uri url = Uri.parse("https://wa.me/$phone?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception("WhatsApp is not installed");
    }
  }



  Future<void> sendSubscriptionAlert(String type, String section) async {

    final userId = await FirebaseAuthentication().getFirebaseUid();

    SubscriptionMailEntity subscriptionMailEntity = SubscriptionMailEntity(
        section: section,
        level: type,
        id: userId ?? "no-id",
        event: "subscription",
        currentLevel: globalSubscriptionStatus.value.name
    );

    showAppSnackBar("Requesting access", backgroundColor: HexColor(lightBlue));

    final results = await profileUsecase.sendSubscriptionMail(subscriptionMailEntity);

    if(results is SuccessState) {
      debugPrint("sent");
      showAppSnackBar("Request for access sent", backgroundColor: HexColor(lightBlue));
    } else {
      showAppSnackBar("Request sending unsuccessful");
    }
  }


  Future<void> discoverLimitReached(BuildContext context) async {
    checkpoint = "profile-limit";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpScreen(
              arguments: const {
                'type': AuthenticationType.signup,
              }
          ))
      );
    });
  }

}