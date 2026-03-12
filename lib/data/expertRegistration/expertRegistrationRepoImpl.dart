
import 'package:reachx_embed/core/helper/imageResizer.dart';
import 'package:reachx_embed/data/data_source/cal_service/eventTypes.dart';
import 'package:reachx_embed/data/data_source/cal_service/schedules.dart';
import 'package:reachx_embed/data/data_source/remote/fileUploader.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/deleteFromFireStore.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/getFromFireStore.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/updateInFireStore.dart';
import 'package:reachx_embed/data/data_source/remote/googlePlaceSearch.dart';
import 'package:reachx_embed/data/models/expertsModel.dart';
import 'package:reachx_embed/data/models/topicModel.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/sessionEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/domain/expertRegistration/expertRegistrationRepo.dart';
import 'package:reachx_embed/data/models/sessionModel.dart';

/// Implementation of ExpertRegistrationRepo for handling expert registration data.
class ExpertRegistrationRepoImpl implements ExpertRegistrationRepo {
  final GetFromFirestore _getFromFirestore = GetFromFirestore();
  final UpdateInFirestore _updateInFirestore = UpdateInFirestore();
  final DeleteFromFirestore _deleteFromFirestore = DeleteFromFirestore();

  final Schedules _schedules = Schedules();
  final EventTypes _eventType = EventTypes();

  final FileUploader _fileUploader = FileUploader();
  final GooglePlaceSearch _googlePlaceSearch =GooglePlaceSearch();



  List<String> topicIds = [];
  List<String> topicGroupIds = [];

  Map<String, dynamic> imageProperties ={};
  List<Map<String, dynamic>> audioProperties = [];

  List<String> placeSearch = [];


  List<Future<int>> eventFutures = [];


  @override
  Future<ExpertEntity> fetchExpertDetails() async {
    ExpertModel expertModel = await _getFromFirestore.getExpertProfileDetails();

    return expertModel;
  }

  @override
  Future<List<String>> locationSearch(String searchText) async {
    Map<String, dynamic> data = await _googlePlaceSearch.getLocationResults(searchText);

   if(data.isNotEmpty) {
     List<dynamic> places = data["places"];
     placeSearch = places.take(10).map((place) {
       return "${place["displayName"]["text"]}, ${place["formattedAddress"]}";
     }).toList();
   }
    return placeSearch;
  }



  @override
  Future<bool> saveImage(var selectedFile, {bool haveTopic = false}) async {
    final resizedImage = await resizeImage(selectedFile);
    bool fileExists = resizedImage != null;

    if(fileExists) {
      imageProperties = await _fileUploader.uploadFile(resizedImage);
    }

    if(imageProperties.isNotEmpty) {
      Map<String, dynamic> data = {
        "imageId" : imageProperties["public-id"],
        "imageFile" : imageProperties["media-url"]
      };

      if(haveTopic) {
        _updateInFirestore.updateImageIntoTopic(data["imageFile"]);
      }

      return _updateInFirestore.updateExpertEdit(data);
    }
    return false;
  }

  @override
  Future<bool> saveBasicRegistration(Map<String, dynamic> data, {bool haveTopic = false}) {

    if(data.keys.contains("name")) {
      Map<String, dynamic> userData = {
        "name": data["name"]
      };
      _updateInFirestore.updateUserDetails(userData);

      if(haveTopic) {
        _updateInFirestore.updateNameIntoTopic(data["name"]);
      }
    }

    if(data.keys.contains("languages") && haveTopic) {
     _updateInFirestore.updateLanguagesIntoTopic(data["languages"]);
    }
    return _updateInFirestore.updateExpertEdit(data);
  }

  @override
  // Fetches detailed information about a specific topic by its ID
  Future<TopicEntity> fetchTopicDetail(String topicId) async {
    TopicModel topicModel = await _getFromFirestore.getTopic(id: topicId);
    
    TopicEntity topicEntity = TopicEntity(
        name: topicModel.name,
        description: topicModel.description,
        sessionType: topicModel.sessionType,
        session: topicModel.session,
        topicRate: topicModel.topicRate,
        expertName: topicModel.expertName,
        topicId: topicModel.topicId,
        expertId: topicModel.expertId,
        expertise: topicModel.expertise,
        sessionId: topicModel.sessionId,
        skillType: topicModel.skillType,
        count: topicModel.count,
        audio: topicModel.audio,
        audioId: topicModel.audioId,
        currencySymbol: topicModel.currencySymbol,
        momentsIds: topicModel.momentsIds,
        imageUrl: topicModel.imageUrl,
        availability: topicModel.availability,
        keywordId: topicModel.keywordId
    );

    return topicEntity;
  }
  

  @override
  Future<SessionEntity> fetchSessionDetail(String uniqueId) async {
    SessionModel sessionModel = await _getFromFirestore.getSessionDetail(uniqueId);

    return SessionEntity(
      sessionId: sessionModel.sessionId,
      session: sessionModel.session,
      sessionType: sessionModel.sessionType,
      scheduleId: sessionModel.scheduleId,
      groupCount: sessionModel.groupCount,
      groupSlotLeft: sessionModel.groupSlotLeft,
      dateTime: sessionModel.dateTime,
      timeInterval: sessionModel.timeInterval,
      link: sessionModel.link,
      location: sessionModel.location,
      weekdays: sessionModel.weekdays,
      selectedHours: sessionModel.selectedHours,
      eventId: sessionModel.eventId
    );
  }


  @override
  Future<bool> deleteTopic(String eventId, TopicEntity topicEntity, SessionEntity sessionEntity) async {
    List<Future<bool>> futures = [];

    if(topicEntity.session != "Not-Given") {
      if (topicEntity.sessionType == "1:1") {
        _eventType.deleteEvent(sessionEntity.eventId);
        _schedules.deleteSchedule(scheduleId: sessionEntity.scheduleId);
      }
      futures.add(_deleteFromFirestore.deleteSession(sessionEntity.sessionId));
    }

    futures.add(_deleteFromFirestore.deleteEvent(eventId));
    futures.add(_deleteFromFirestore.deleteExpertTopic(eventId));

    final responses = await Future.wait(futures);

    return !responses.contains(false);
  }


  @override
  Future<bool> updateAchievements(String value, String type) {
    return _updateInFirestore.updateAchievements(value, type);
  }
}
