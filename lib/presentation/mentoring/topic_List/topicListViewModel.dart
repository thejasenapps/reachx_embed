
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/core/helper/searchAIGenerator.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/domain/topicList/topicListUsecase.dart';


class TopicListViewModel extends GetxController {
  final TopicListUsecase _topicListUsecase = TopicListUsecase();

  final SearchGenAIGenerator searchGenAIGenerator = SearchGenAIGenerator();
  final AudioPlayer audioPlayer = AudioPlayer();

  RxBool isLoading = true.obs; // Observes the loading state for UI updates.
  RxBool isPlaying = false.obs;
  RxBool isKeyboardOpen = false.obs;

  String query = ''; // Stores the search query.
  TopicsEntity? topicList; // Holds the fetched list of topics.
  String? filePath;
  String? userId;
  String currentAudio = '';
  String response = '';
  String aiResponse = '';

  TextEditingController searchController = TextEditingController();

  Future<void> fetchTopicList({String search = ''}) async {
    Results? results;

    isLoading.value = true; // Start loading animation/spinner.

    userId = await FirebaseAuthentication().getFirebaseUid(); // Get current user ID.

    if(search.isNotEmpty && query.isEmpty) {
      query = search;
    }

    // Fetch either all topics or filtered ones based on the search query.
    if (query == '') {
      results = await _topicListUsecase.fetchTopicList();
    } else {
      results = await _topicListUsecase.fetchTopicList(search: query, type: "expertise");
      _topicListUsecase.saveSearch(query);
    }

    // Handle API response: success, error, or failure
    if(results is SuccessState )  {
      topicList = results.value;
      if(query.isNotEmpty) {
        searchGenAIGenerator.getText(query, true); // Notify AI generator of success.
      }
      isLoading.value = false;
      response = "Success";
    } else if(results is ErrorState && results.msg is String) {
      topicList = TopicsEntity(topics: []);
      isLoading.value = false;
      response =  "Limit";
    } else {
      topicList = TopicsEntity(topics: []);
      if(query.isNotEmpty) {
        searchGenAIGenerator.getText(query, false); // Notify AI generator of failure.
      }
      isLoading.value = false;
      response =  "Failure";
    }
  }


  Future<bool> playAudio(String audioFile) async {
    try {
      if(currentAudio == audioFile && isPlaying.value) {
        // If same audio is already playing, pause it
        await pauseAudio();
        return false;
      }

      await audioPlayer.stop(); // Stop any previous playback
      isPlaying.value = false;

      if (audioFile.isNotEmpty) {
        await audioPlayer.setUrl(audioFile);
        audioPlayer.play();
        isPlaying.value = true;
        currentAudio = audioFile;

        // Reset playback state on audio completion
        audioPlayer.playerStateStream.listen((playerState) {
          if(playerState.processingState == ProcessingState.completed) {
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


  Future<void> pauseAudio() async {
    try {
      await audioPlayer.pause();
      isPlaying.value = false;
      currentAudio = '';
    } catch(e) {
      print("Error pausing audio: $e");
    }
  }
}

