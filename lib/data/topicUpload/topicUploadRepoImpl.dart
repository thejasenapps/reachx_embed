
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reachx_embed/core/global_passion.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/data_source/cal_service/eventTypes.dart';
import 'package:reachx_embed/data/data_source/cal_service/schedules.dart';
import 'package:reachx_embed/data/data_source/remote/fileUploader.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/deleteFromFireStore.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/getFromFireStore.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/saveInFirestore.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/updateInFireStore.dart';
import 'package:reachx_embed/data/data_source/remote/pushNotifications.dart';
import 'package:reachx_embed/data/data_source/remote/supabase/social_feed/deleteFromSupabase.dart';
import 'package:reachx_embed/data/data_source/remote/supabase/social_feed/saveInFeedSupabase.dart';
import 'package:reachx_embed/data/data_source/remote/supabase/social_feed/updateInFeedSupabase.dart';
import 'package:reachx_embed/data/data_source/semantic_search/chromaDB.dart';
import 'package:reachx_embed/data/models/expertsModel.dart';
import 'package:reachx_embed/data/models/feedModel.dart';
import 'package:reachx_embed/data/models/requestModel.dart';
import 'package:reachx_embed/data/models/topicModel.dart';
import 'package:reachx_embed/data/models/userModel.dart';
import 'package:reachx_embed/domain/entities/requestEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/domain/topicUpload/topicUploadRepo.dart';

class TopicUploadRepoImpl implements TopicUploadRepo {

  final FileUploader _fileUploader = FileUploader();
  final ChromaDB _chromaDB = ChromaDB();
  final PushNotifications _notifications = PushNotifications();
  final EventTypes _eventTypes = EventTypes();
  final Schedules _schedules = Schedules();

  final GetFromFirestore _getFromFirestore = GetFromFirestore();
  final SaveInFirestore _saveInFirestore = SaveInFirestore();
  final UpdateInFirestore _updateInFirestore = UpdateInFirestore();
  final DeleteFromFirestore _deleteFromFirestore = DeleteFromFirestore();

  final SaveInFeedSupabase _saveInFeedSupabase = SaveInFeedSupabase();
  final UpdateInFeedSupabase _updateInFeedSupabase = UpdateInFeedSupabase();
  final DeleteFromFeedSupabase _deleteFromFeedSupabase = DeleteFromFeedSupabase();


  @override
  Future<bool> saveTopic(TopicEntity topicEntity) async {
    try {
      ExpertModel expertModel = await _getFromFirestore.getExpertProfileDetails();
      final userId = await FirebaseAuthentication().getFirebaseUid();

      if(topicEntity.audio is XFile) {
        final bytes = await topicEntity.audio.readAsBytes();
        topicEntity.audio = await _fileUploader.uploadFile(bytes);
      }

      if(topicEntity.keywordId != null && topicEntity.keywordId!.isNotEmpty) {
        await assignSearchCode(topicEntity.name, topicEntity.description, keywordId: topicEntity.keywordId!);
      }

      TopicModel topicModel = TopicModel(
          expertId: userId,
          sessionId: topicEntity.sessionId,
          name: topicEntity.name,
          keywordId: topicEntity.keywordId,
          description: topicEntity.description,
          session: topicEntity.session,
          sessionType: topicEntity.sessionType,
          topicRate: topicEntity.topicRate,
          expertName: expertModel.name,
          topicId: topicEntity.topicId,
          location: topicEntity.location,
          expertise: [],
          status: "online",
          skillType: topicEntity.skillType,
          imageUrl: expertModel.imageFile,
          audio: topicEntity.audio == null ? '' : topicEntity.audio["media-url"],
          audioId: topicEntity.audio == null ? '' : topicEntity.audio["public-id"],
          languages: [],
          currencySymbol: topicEntity.currencySymbol,
          availability: topicEntity.availability
      );


      bool response = await _saveInFirestore.saveTopics(topicModel, topicModel.topicId);
      if(response) {

        await _updateInFirestore.updateExpertTopic(topicModel.topicId);
        _updateInFirestore.updateStatusIntoTopic("online");

        _updateInFirestore.updateExpertBasics(
          {
            "status": "online"
          }
        );

        uploadToFeed("save", topicModel);
      }
      return response;
    } catch (e) {
      debugPrint('Error saving topic details: $e');
      return false;
    }
  }


  @override
  Future<bool> updateTopic(TopicEntity topicEntity) async {
    try {
      ExpertModel expertModel = await _getFromFirestore.getExpertProfileDetails();
      final userId = await FirebaseAuthentication().getFirebaseUid();

      if(topicEntity.audio is XFile) {
        final bytes = await topicEntity.audio.readAsBytes();
        topicEntity.audio = await _fileUploader.uploadFile(bytes);
      }


      if(topicEntity.keywordId != null && topicEntity.keywordId!.isNotEmpty) {
        await assignSearchCode(topicEntity.name, topicEntity.description, keywordId: topicEntity.keywordId!);
      }

      TopicModel topicModel = TopicModel(
          expertId: userId,
          sessionId: topicEntity.sessionId,
          keywordId: topicEntity.keywordId,
          name: topicEntity.name,
          description: topicEntity.description,
          session: topicEntity.session,
          sessionType: topicEntity.sessionType,
          topicRate: topicEntity.topicRate,
          expertName: expertModel.name,
          topicId: topicEntity.topicId,
          location: topicEntity.location,
          expertise: [],
          status: "online",
          skillType: topicEntity.skillType,
          imageUrl: expertModel.imageFile,
          audio: topicEntity.audio is XFile ? topicEntity.audio["media-url"] : topicEntity.audio,
          audioId: topicEntity.audio is XFile ? topicEntity.audio["public-id"] : topicEntity.audio,
          languages: [],
          currencySymbol: topicEntity.currencySymbol,
          availability: topicEntity.availability,
          momentsIds: topicEntity.momentsIds
      );


      bool response = await _updateInFirestore.updateEvent(topicModel.toJson(), topicModel.topicId);

      if(response) {
        uploadToFeed("update", topicModel);
      }
      return response;
    } catch (e) {
      debugPrint('Error saving topic details: $e');
      return false;
    }
  }


  @override
  Future<bool> updateEachTopicEvent(String topicId, String type, Map<String, dynamic> data) async {

    if(type == "audio") {
      if(data["audio"] is XFile) {
        final bytes = await data["audio"].readAsBytes();
        final media = await _fileUploader.uploadFile(bytes);
        data["audio"] = media["media-url"];
        data["audioId"] = media["public-id"];
      }
    }

    if(type == "topicDescription") {
      assignSearchCode(data["name"], data["description"], keywordId: data["keywordId"]);
    }

    if(type == "availability"  && data["sessionId"].isNotEmpty) {
      sendAvailabilityNotifications();
    }

    if(data["scheduleId"] != null && data["scheduleId"] != 0) {
      _schedules.deleteSchedule(scheduleId:data["scheduleId"]);
      data.remove("scheduleId");
    }

    if(data["eventId"] != null && data["eventId"] != 0) {
      _eventTypes.deleteEvent(data["eventId"]);
      data.remove("eventId");
    }

    return _updateInFirestore.updateEvent(data, topicId);
  }


  @override
  Future<bool> deleteAvailability(String sessionId) {
    return _deleteFromFirestore.deleteSession(sessionId);
  }


  Future<void> sendAvailabilityNotifications() async{

    try {
      final futures = [_getFromFirestore.getUserProfileDetails(), _getFromFirestore.getRequests()];
      final responses = await Future.wait(futures);

      UserModel users = responses[0] as UserModel;
      Results results = responses[1] as Results;

      String expertName = users.name;

      if(results is SuccessState) {
        MultipleRequestsModel multipleRequestsModel = results.value as MultipleRequestsModel;

        final Set<String> notifyTokens = {};
        final List<Future<UserModel>> userFutures = [];
        final List<Future<bool>> deleteFutures = [];

        for(RequestEntity request in multipleRequestsModel.requests) {
          userFutures.add(_getFromFirestore.getUserDetails(request.userId));
          deleteFutures.add(_deleteFromFirestore.deleteRequestData(request.requestId));
        }

        final userResults = await Future.wait(userFutures);

        notifyTokens.addAll(
            userResults.where((user) => user.fcmToken!.isNotEmpty)
                .map((user) => user.fcmToken!)
        );

        _notifications.sendPushNotifications(
            notifyTokens.toList(),
            "Available",
            "Mr. $expertName is available. Check and book your ReachX session.",
            {}
        );

        Future.wait(deleteFutures);

      }
    } catch(e) {
      debugPrint(e.toString());
    }
  }


  @override
  Future<int> getReachXCharge() {
    return _getFromFirestore.getPaymentCharge();
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



  Future<void> uploadToFeed(String type, dynamic data) async {
    switch(type) {
      case 'save': {
        final TopicModel topicModel = data as TopicModel;

        final FeedDataModel feedDataModel = FeedDataModel(
            title: topicModel.name,
            mediaUrl: '',
            description: topicModel.description,
            expertImageUrl: topicModel.imageUrl ?? '',
            expertName: topicModel.expertName ?? ''
        );

        String postType = "";

        if(topicModel.sessionType == "1:1") {
          postType = "1:1";
        } else if(topicModel.sessionType == "Group") {
          postType == "WEBINAR";
        }

        insertFeed(feedDataModel, topicModel.topicId, postType);
      } break;
      case 'update': {
        final TopicModel topicModel = data as TopicModel;

        updateFeed(topicModel);
      } break;
      case 'delete': {
        String postType = "";

        final TopicModel topicModel = data as TopicModel;

        if(topicModel.sessionType == "1:1") {
          postType = "1:1";
        } else if(topicModel.sessionType == "Group") {
          postType == "WEBINAR";
        }

        deleteFeed(topicModel.topicId, postType);

      } break;
    }
  }



  Future<void> insertFeed(FeedDataModel feedDataModel, String postId, String postType) async {

    if(globalPassions.isNotEmpty && globalPassions.first.badgeId != null) {

      final FeedModel feedModel = FeedModel(
          postData: feedDataModel,
          postType: postType,
          badgeId: globalPassions.first.badgeId!,
          postId: postId,
          creatorId: globalUserId.value
      );

      final result = _saveInFeedSupabase.insertFeedPost(feedModel);
    }
  }


  Future<void> updateFeed(TopicModel topicModel) async {

    final FeedDataModel feedDataModel = FeedDataModel(
        title: topicModel.name,
        mediaUrl: '',
        description: topicModel.description,
        expertImageUrl: globalExpertEntity.value.imageFile,
        expertName: globalExpertEntity.value.name
    );

    String postType = "";

    if(topicModel.sessionType == "1:1") {
      postType = "1:1";
    } else if(topicModel.sessionType == "Group") {
      postType == "WEBINAR";
    }

    final Map<String, dynamic> data = {
      "postId": topicModel.topicId,
      "userId": globalUserId.value,
      "postType": postType,
      "newPostType": postType,
      "newPostData": feedDataModel.toJson()
    };

    final result = _updateInFeedSupabase.updateFeedPost(data);
  }

  Future<void> deleteFeed(String topicId, String postType) async {
    final result = _deleteFromFeedSupabase.deleteFeedPost(
        globalUserId.value,
        topicId,
        postType
    );
  }
}