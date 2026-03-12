import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/getFromFireStore.dart';
import 'package:reachx_embed/data/data_source/remote/pushNotifications.dart';
import 'package:reachx_embed/data/data_source/remote/reportUser.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/saveInFirestore.dart';
import 'package:reachx_embed/data/models/expertsModel.dart';
import 'package:reachx_embed/data/models/momentModel.dart';
import 'package:reachx_embed/data/models/requestModel.dart';
import 'package:reachx_embed/data/models/sessionModel.dart';
import 'package:reachx_embed/data/models/topicModel.dart';
import 'package:reachx_embed/data/models/userModel.dart';
import 'package:reachx_embed/data/models/viewCountModel.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/momentEntity.dart';
import 'package:reachx_embed/domain/entities/sessionEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/domain/entities/viewCountEntity.dart';
import 'package:reachx_embed/domain/expertDetail/expertDetailRepo.dart';
import 'package:uuid/uuid.dart';

class ExpertDetailRepoImpl implements ExpertDetailRepo {

  final GetFromFirestore _getFromFirestore = GetFromFirestore();
  final SaveInFirestore _saveInFirestore = SaveInFirestore();
  final ReportUser _reportUser = ReportUser();
  final PushNotifications _notifications = PushNotifications();

  late ExpertModel expertModel;
  List<bool> results = [];

  @override
  Future<ExpertEntity> fetchExpertDetails(String expertId) async {
    ExpertModel expertModel = await _getFromFirestore.getExpertDetails(expertId);

    ExpertEntity expertEntity = ExpertEntity(
        uniqueId: expertModel.uniqueId,
        name: expertModel.name,
        minutes: expertModel.minutes,
        topics: expertModel.topics,
        intro: expertModel.intro,
        location: expertModel.location,
        experience: expertModel.experience,
        achievements: expertModel.achievements,
        languages: expertModel.languages,
        imageFile: expertModel.imageFile
    );

    return expertEntity;
  }


  @override
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
        skillType: topicModel.skillType,
        rating: topicModel.rating,
        location: topicModel.location,
        sessionId: topicModel.sessionId,
        audio: topicModel.audio,
        currencySymbol: topicModel.currencySymbol,
        momentsIds: topicModel.momentsIds,
        availability: topicModel.availability,
        status: topicModel.status,
        imageUrl: topicModel.imageUrl,
        meetingUrl: topicModel.meetingUrl
    );

    return topicEntity;
  }


  @override
  Future<SessionEntity> fetchSessionDetail(String uniqueId) async {
    SessionModel sessionModel = await _getFromFirestore.getSessionDetail(uniqueId);

    SessionEntity sessionEntity = SessionEntity(
      sessionId: sessionModel.sessionId,
      session: sessionModel.session,
      sessionType: sessionModel.sessionType,
      selectedHours: sessionModel.selectedHours,
      scheduleId: sessionModel.scheduleId,
      location: sessionModel.location,
      dateTime: sessionModel.dateTime,
      link: sessionModel.link,
      groupCount: sessionModel.groupCount,
      groupSlotLeft: sessionModel.groupSlotLeft,
      weekdays: sessionModel.weekdays,
      timeInterval: sessionModel.timeInterval,
      eventId: sessionModel.eventId,
    );

    return sessionEntity;
  }

  @override
  Future<Results> getMoments(String topicId) async {
    TopicModel topicModel = await _getFromFirestore.getTopic(id: topicId);
    List<String> momentsIds = topicModel.momentsIds!;

    if (momentsIds.isNotEmpty) {
      List<MomentModel> momentModels = await Future.wait(
        momentsIds.map((id) => _getFromFirestore.getMoments(id)),
      );

      List<MomentEntity> momentEntities = momentModels.map((model) => MomentEntity(
        selectedImage: model.selectedImage,
        description: model.description,
        date: model.date,
        imageId: model.imageId,
        momentId: model.momentId,
        timestamp: model.timestamp
      )).toList();

      return Results.success([
        MomentsEntity(moments: momentEntities),
        topicModel.expertId,
        topicModel.name
      ]);
    } else {
      return Results.error(false);
    }
  }

  @override
  Future<Results> reportExpert(String expertId) {
    return _reportUser.reportExpert(expertId);
  }

  @override
  Future<bool> profileViewCount(ViewCountEntity viewCountEntity) {
    final viewCountModel = ViewCountModel.fromEntity(viewCountEntity);
    return _saveInFirestore.saveProfileViewCount(viewCountModel);
  }


  @override
  Future<bool> sendRequest(String expertId, String expertName) async {

    UserModel userModel = await _getFromFirestore.getUserDetails(expertId);

    if(userModel.fcmToken != null) {
      bool result = await _notifications.sendPushNotifications(
          [userModel.fcmToken!],
          "Appointment Request",
          "Someone has requested your availability. Please update your available time in your profile.",
          {}
      );

      print(result);
    }


    final userId = await FirebaseAuthentication().getFirebaseUid();

    final requestId = const Uuid().v4();

    RequestModel requestModel = RequestModel(
        requestId: requestId,
        expertId: expertId,
        timestamp: DateTime.now(),
        userId: userId ?? ''
    );

    return _saveInFirestore.saveRequest(requestModel, requestId);
  }

}
