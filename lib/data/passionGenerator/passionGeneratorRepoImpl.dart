import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reachx_embed/core/constants/enums.dart';
import 'package:reachx_embed/core/global_passion.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/data_source/cal_service/eventTypes.dart';
import 'package:reachx_embed/data/data_source/cal_service/schedules.dart';
import 'package:reachx_embed/data/data_source/local/hive/localuserDatabse.dart';
import 'package:reachx_embed/data/data_source/local/sharedPreferenceServices.dart';
import 'package:reachx_embed/data/data_source/remote/badgeSelectorApis.dart';
import 'package:reachx_embed/data/data_source/remote/fileUploader.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/getFromFireStore.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/saveInFirestore.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/updateInFireStore.dart';
import 'package:reachx_embed/data/data_source/remote/supabase/getFromSupabase.dart';
import 'package:reachx_embed/data/data_source/remote/supabase/social_feed/saveInFeedSupabase.dart';
import 'package:reachx_embed/data/data_source/semantic_search/chromaDB.dart';
import 'package:reachx_embed/data/expertRegistration/eventModel.dart';
import 'package:reachx_embed/data/models/badgeModel.dart';
import 'package:reachx_embed/data/models/expertsModel.dart';
import 'package:reachx_embed/data/models/feedModel.dart';
import 'package:reachx_embed/data/models/scheduleModel.dart';
import 'package:reachx_embed/data/models/streakModel.dart';
import 'package:reachx_embed/data/models/topicModel.dart';
import 'package:reachx_embed/data/models/userModel.dart';
import 'package:reachx_embed/data/passionGenerator/passionGeneratorModel.dart';
import 'package:reachx_embed/domain/entities/badgeEntity.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/domain/expertRegistration/eventEntity.dart';
import 'package:reachx_embed/domain/passionGenerator/passionGeneratorEntity.dart';
import 'package:reachx_embed/domain/passionGenerator/passionGeneratorRepo.dart';
import 'package:reachx_embed/data/hiveModels/userModel.dart' as localUser;

class PassionGeneratorRepoImpl implements PassionGeneratorRepo {

  final SharedPreferenceServices _sharedPreferenceServices = SharedPreferenceServices();
  final LocalUserDatabase _localUserDatabase = LocalUserDatabase();
  final UpdateInFirestore _updateInFirestore = UpdateInFirestore();
  final GetFromFirestore _getFromFirestore = GetFromFirestore();
  final BadgeSelectorApis _badgeSelector = BadgeSelectorApis();
  final GetFromSupabase _getFromSupabase = GetFromSupabase();
  final SaveInFirestore _saveInFirestore = SaveInFirestore();
  final FileUploader _fileUploader = FileUploader();
  final EventTypes _eventTypes = EventTypes();
  final Schedules _schedules = Schedules();
  final ChromaDB _chromaDB = ChromaDB();


  final SaveInFeedSupabase _saveInFeedSupabase = SaveInFeedSupabase();

  @override
  Future<Results> fetchQuestions() async {
    return _getFromFirestore.getPassionateQuestions();
  }

  @override
  Future<Results> savePassion(ExpertEntity expertEntity, TopicEntity topicEntity) async {
    try {
      ExpertModel expertModel = ExpertModel(
        uniqueId: expertEntity.uniqueId,
        name: expertEntity.name,
        minutes: expertEntity.minutes,
        intro: expertEntity.intro,
        location: expertEntity.location,
        experience: expertEntity.experience,
        topics: expertEntity.topics,
        status: expertEntity.status,
        languages: expertEntity.languages,
        imageId: expertEntity.imageId,
        imageFile: expertEntity.imageFile,
        isExpert: expertEntity.isExpert,
        timestamp: DateTime.now(),
        achievements: expertEntity.achievements
      );

      final response = await _saveInFirestore.saveExpertDetails(expertModel);

      if(response) {
        return saveOnlyPassion(topicEntity, only: false);
      } else {
        return Results.error("Error saving passionate details");
      }
    } catch (e) {
      debugPrint("Error: $e");
      return Results.error("Unknown error: $e");
    }
  }


  @override
  Future<Results> saveOnlyPassion(TopicEntity topicEntity, {bool only = true})  async {
    try {
      if(topicEntity.audio is XFile) {
        final bytes = await topicEntity.audio.readAsBytes();
        topicEntity.audio = await _fileUploader.uploadFile(bytes);
      }

      if(topicEntity.keywordId != null && topicEntity.keywordId!.isNotEmpty) {
        await assignSearchCode(topicEntity.name, topicEntity.description, keywordId: topicEntity.keywordId!);
      }


      TopicModel topicModel = TopicModel(
          expertId: topicEntity.expertId,
          name: topicEntity.name,
          description: topicEntity.description,
          sessionId: topicEntity.sessionId,
          session: topicEntity.session,
          sessionType: topicEntity.sessionType,
          topicRate: topicEntity.topicRate,
          expertName: topicEntity.expertName,
          topicId: topicEntity.topicId,
          availability: topicEntity.availability,
          status: topicEntity.status,
          skillType: topicEntity.skillType,
          imageUrl: topicEntity.imageUrl,
          audio: topicEntity.audio,
          languages: topicEntity.languages,
          currencySymbol: topicEntity.currencySymbol,
          keywordId: topicEntity.keywordId,
          timestamp: DateTime.now()
      );

      final response = await _saveInFirestore.saveTopics(topicModel, topicModel.topicId);

      if(response) {
        if(only) {
          await Future.wait([
            _updateInFirestore.updateExpertTopic(topicModel.topicId),
            _updateInFirestore.updateStatusIntoTopic(topicModel.status!)
          ]);
        }

        return Results.success("Successfully saved topic");
      }
      return Results.error("Error saving topic details");
    } catch(e) {
      debugPrint(e.toString());
      return Results.error("Unknown error: $e");
    }
  }


  @override
  Future<int> getGeneratorTries(String storage) async {
    final response = await _sharedPreferenceServices.getValue(storage);

    if(response == null) {
      _sharedPreferenceServices.setValue(storage, 2);
      return 2;
    }
    return response;
  }

  @override
  void setGeneratorTries(String storage, int value) {
    _sharedPreferenceServices.setValue(storage, value);
  }

  Future<String> assignSearchCode(String name, String description, {String keywordId = ''}) async {
    try {
      if(name.isNotEmpty) {
        Results results = await _chromaDB.addKeyword(keywordId, "$name: $description");

        if(results is SuccessState) {
          return results.value;
        }
      }

      return '';
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

  @override
  Future<UserType> checkIfPassionate(String expertId) async {
    final futures = [
      _getFromFirestore.getUserDetails(expertId),
      _getFromFirestore.getExpertPassions(expertId),
    ];

    final responses = await Future.wait(futures);

    final userModel = responses[0] as UserModel;
    final topicsModel = responses[1] as TopicsModel;

    // If user has no uniqueId → normal user
    if (userModel.phoneNo.isEmpty) {
      return UserType.user;
    }

    // If no topics → expert by default
    if (topicsModel.topics.isEmpty) {
      return UserType.expert;
    }

    // Check if any topic has skillType == "lifeSkill"
    final hasLifeSkill = topicsModel.topics
        .any((topic) => topic.skillType == "lifeSkill");

    return hasLifeSkill ? UserType.passionate : UserType.expert;
  }


  Future<int> createEvent(EventEntity eventEntity) async {
    EventModel eventModel = EventModel(
        title: eventEntity.title,
        slug: eventEntity.slug,
        description: eventEntity.description,
        lengthInMinutes: eventEntity.lengthInMinutes,
        lengthInMinutesOptions: eventEntity.lengthInMinutesOptions,
        scheduleId: eventEntity.scheduleId
    );
    Results result = await _eventTypes.createEvent(eventModel);

    if(result is SuccessState) {
      int eventId = result.value;
      return eventId;
    } else {
      return 0;
    }
  }

  @override
  Future<int> getReachXCharge() {
    return _getFromFirestore.getPaymentCharge();
  }

  @override
  Future<Results> saveStreakData(StreakModel streakModel) {
    return _saveInFirestore.saveStreak(streakModel);
  }


  @override
  Future<Results> updatePassion(TopicEntity topicEntity) async {
    try {

      TopicModel topicModel = TopicModel(
          expertId: topicEntity.expertId,
          name: topicEntity.name,
          description: topicEntity.description,
          sessionId: topicEntity.sessionId,
          session: topicEntity.session,
          sessionType: topicEntity.sessionType,
          topicRate: topicEntity.topicRate,
          expertName: topicEntity.expertName,
          topicId: topicEntity.topicId,
          availability: topicEntity.availability,
          status: topicEntity.status,
          skillType: topicEntity.skillType,
          imageUrl: topicEntity.imageUrl,
          audio: topicEntity.audio,
          languages: topicEntity.languages,
          currencySymbol: topicEntity.currencySymbol,
          keywordId: topicEntity.keywordId
      );

      final response = await _updateInFirestore.updateEvent(
          topicModel.toJson(),
          topicModel.topicId
      );

      if(response) {
        return Results.success("Successfully updated topic");
      }
      return Results.error("Error saving topic details");
    } catch(e) {
      debugPrint(e.toString());
      return Results.error("Unknown error: $e");
    }
  }


  @override
  Future<BadgeEntityList> getBadges(String title) async {
    try {
      
      BadgeEntityList badgeEntityList = BadgeEntityList(badges: []);

      final response = await _badgeSelector.getSearchCode(title);
      
      if(response is SuccessState) {
        final List<String> keywordList =
        List<String>.from(
          (response.value['documents'][0] as List)
              .map((e) => e.toString()),
        );


        // for(int index = 0; index < keywordList.length; index++) {
        //   final BadgeModelList badgeModelList = await _getFromSupabase.getBadges(keywordList);
        //   badgeEntityList.badges.add(badgeModelList.badges.first);
        // }

        final BadgeModelList badgeModelList = await _getFromSupabase.getBadges(keywordList);
        badgeEntityList.badges.addAll(badgeModelList.badges);
        
        if(badgeEntityList.badges.isNotEmpty) {
          return badgeEntityList;
        } 
      }

      return BadgeEntityList(badges: []);
    } catch (e) {
      debugPrint(e.toString());
      return BadgeEntityList(badges: []);
    }
  }

  @override
  Future<Results> saveBadge(String badgeId, TopicEntity topicEntity) async {
    try {
      final Map<String, dynamic> updateData = {
        "badgeId": badgeId
      };

      final futures = [
        _updateInFirestore.updateBadgeIntoTopic(topicEntity.topicId, updateData),
        _updateInFirestore.updateExpertBadges(badgeId)
      ];

      final response = await Future.wait(futures);
      if(globalPassions.isNotEmpty) {
        globalPassions.first.badgeId = badgeId;
      }

      saveFeed(topicEntity, badgeId);

      if(response[0] is SuccessState) {

        return Results.success("Saved Successfully");
      }
      return Results.error("Save unsuccessful");
    } catch(e) {
      debugPrint(e.toString());
      return Results.error("Unexpected error: $e");
    }
  }


  @override
  Future<String> getCurrentBadge() async {
    try {
      final ExpertModel expertModel = await _getFromFirestore.getExpertProfileDetails();

      return expertModel.badgeId ?? '';
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

  @override
  Future<Results> saveUserLocally(localUser.UserModel userModel)  {
    return _localUserDatabase.saveUser(userModel);
  }

  @override
  Future<Results> deleteUserLocally() async {
    return _localUserDatabase.deleteUser();
  }

  @override
  Future<void> saveDiscoverAnswers(AnswerSheetEntity answerSheetEntity) async {
    AnswerSheetModel answerSheetModel = AnswerSheetModel.fromEntity(answerSheetEntity);
    _saveInFirestore.saveAnswers(answerSheetModel.id, answerSheetModel: answerSheetModel);
  }

  @override
  Future<void> updateDiscoverAnswers(String id, Map<String,dynamic> data) async {
    _updateInFirestore.updateAnswers(id, data);
  }


  Future<int> createSchedule(List<String> selectedTimeInterval, List<String> selectedDays, String scheduleName) async{
    ScheduleModel scheduleModel = ScheduleModel(
        name: scheduleName,
        timeZone: "Asia/Calcutta",
        availability: [
          TimeDaysModel(
            days: selectedDays,
            startTime: selectedTimeInterval[0],
            endTime: selectedTimeInterval[1],
          ),
        ],
        isDefault: false
    );

    Results result = await _schedules.createSchedule(scheduleModel: scheduleModel);
    if(result is SuccessState) {
      int scheduleId = result.value;

      return scheduleId;
    } else {
      return 0;
    }
  }

  Future<void> saveFeed(TopicEntity topicEntity, String badgeId) async {
    final FeedDataModel feedDataModel = FeedDataModel(
        title: topicEntity.name,
        mediaUrl: '',
        description: topicEntity.description,
        expertImageUrl: topicEntity.imageUrl ?? '',
        expertName: topicEntity.expertName ?? ''
    );

    if(badgeId.isNotEmpty) {

      final FeedModel feedModel = FeedModel(
          postData: feedDataModel,
          postType: "PASSION",
          badgeId: badgeId,
          postId: topicEntity.topicId,
          creatorId: topicEntity.expertId!
      );

      final result = _saveInFeedSupabase.insertFeedPost(feedModel);
    }
  }
}