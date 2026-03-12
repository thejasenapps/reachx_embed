import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reachx_embed/core/global_variables.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/domain/entities/userEntity.dart';
import 'package:reachx_embed/domain/expertRegistration/expertRegistrationUsecase.dart';
import 'package:reachx_embed/domain/entities/sessionEntity.dart';

class ExpertRegistrationViewModel extends GetxController{

  ExpertRegistrationUsecase expertRegistrationUsecase = ExpertRegistrationUsecase();

  final ImagePicker _imagePicker = ImagePicker();

  late String uuid;

  Map<String, SessionEntity> sessions = {};
  String skillType = "professional";
  List<File> selectedFiles = [];
  Set<String> selectedInterests = {};
  Set<String> achievements = {};
  Uint8List? imageBytes;
  String fileName = '';


  RxBool isEditLoading = false.obs;
  RxList<String> tiles = <String>[].obs;
  RxSet<String> languages = <String>{}.obs;
  RxBool saveResult = false.obs;
  RxMap<String, TopicEntity> topics = <String, TopicEntity>{}.obs;
  Rxn<dynamic> selectedFile = Rxn<dynamic>();
  RxString location = ''.obs;
  RxBool isLoading = false.obs;


  TextEditingController nameController = TextEditingController();
  TextEditingController introController = TextEditingController();
  TextEditingController tileController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  ExpertEntity expertEntity = ExpertEntity(
      uniqueId: '',
      name: '',
      minutes: 60,
      topics: [],
      intro: '',
      location: '',
      experience: 0,
      languages: [],
      achievements: [],
      imageFile: ''
  );

  TopicEntity topicEntity = TopicEntity(name: '', description: '', session: '', sessionType: '', topicRate: 0, sessionId: '', availability: false, topicId: '');

  UserEntity? userEntity;



  void selectImages() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        fileName = image.name;
        imageBytes = await image.readAsBytes();
        selectedFile.value = image;

        bool haveTopic = topics.isNotEmpty;

        expertRegistrationUsecase.saveImage(selectedFile.value, haveTopic: haveTopic).then((result) {
          if(result) {
            saveResult.value = !saveResult.value;
          } else {
            print("Error saving data");
          }
        }).catchError((error) {
          print("Error saving data");
        });
      }
    } catch(e) {
      print("Error: $e");
    }
  }


  void saveFile(dynamic file) {
    selectedFile.value = file;
  }

  void removeFile(File file) {
    selectedFile.value = null;
    imageBytes!.clear();
  }

  Future<List<String>> getLocationResults(String text) {
      return expertRegistrationUsecase.locationResults(text);
  }


  void saveBasicRegistration(String type) async {

    isEditLoading.value = true;

    Map<String , dynamic>? data;
    if(type == "name") {
      expertEntity.name = nameController.text;
      data = {
        "name": nameController.text,
      };
    } else if(type == "about") {
        expertEntity.intro = introController.text;
        data = {
          "intro": introController.text,
        };
      } else if(type == "achievements") {
        expertEntity.achievements = tiles;
        data = {
          "achievements": tiles
        };
      } else if(type == "location") {
        expertEntity.location = locationController.text;
        data = {
          "location": locationController.text
        };
      } else if(type == "languages") {
        expertEntity.languages = languages.toList();
        data = {
          "languages": languages.toList()
        };
      }

      if(data != null) {
        bool haveTopic = topics.isNotEmpty;
        expertRegistrationUsecase.saveBasicRegistration(data, haveTopic: haveTopic).then((result) {
          if(result) {
            saveResult.value = !saveResult.value;
          } else{
            print("saving incomplete");
          }
        });
      }
    isEditLoading.value = false;
  }


  void updateAchievements(String value, String type) {
    if(type == "add") {
      expertEntity.achievements.add(value);
    } else if(expertEntity.achievements.isNotEmpty) {
      expertEntity.achievements.remove(value);
    }

    expertRegistrationUsecase.updateAchievements(value, type).then((result) {
      if(result) {
        saveResult.value = !saveResult.value;
      } else {
        print("saving incomplete");
      }
    });
  }


  void fetchExpertDetails() async {
    isLoading.value = true;
    expertEntity = await expertRegistrationUsecase.fetchExpertDetails();
    isLoading.value = false;
    if(expertEntity.topics != null) {
      List<String> topicIds = expertEntity.topics!.map((id)  => id.toString()).toList();
      fetchTopicDetails(topicIds);
    }
  }

  void fetchTopicDetails(List<String> topicIds) async {
    for(String id in topicIds) {
      topicEntity = await expertRegistrationUsecase.fetchTopicDetail(id);
      sessions[topicEntity.sessionId] = await expertRegistrationUsecase.fetchSessionDetail(topicEntity.sessionId);
      topics[topicEntity.topicId] = topicEntity;
      topicList.add([topicEntity.topicId, topicEntity.name]);
    }
  }


  Future<void> deleteTopic(String eventId, TopicEntity topicEntity, SessionEntity sessionEntity) async {
    isLoading.value = true;
    bool result = await expertRegistrationUsecase.deleteTopic(eventId, topicEntity, sessionEntity);

    if(result) {
      topics.remove(eventId);
      saveResult.value = !saveResult.value;
    }
    isLoading.value = false;
  }


}
