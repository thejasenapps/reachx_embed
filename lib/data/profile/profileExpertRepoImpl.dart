

import 'package:reachx_embed/core/helper/dateAndTimeConvertors.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/booked/bookedModel.dart';
import 'package:reachx_embed/data/data_source/cal_service/eventTypes.dart';
import 'package:reachx_embed/data/data_source/local/sharedPreferenceServices.dart';
import 'package:reachx_embed/data/data_source/remote/emailNotificationService.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/deleteFromFireStore.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/getFromFireStore.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/updateInFireStore.dart';
import 'package:reachx_embed/data/models/expertsModel.dart';
import 'package:reachx_embed/data/models/sessionModel.dart';
import 'package:reachx_embed/data/models/subscriptionMailModel.dart';
import 'package:reachx_embed/data/models/topicModel.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/sessionEntity.dart';
import 'package:reachx_embed/domain/entities/subscriptionMailEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/domain/profile/profileExpertRepo.dart';

class ProfileExpertRepoImpl implements ProfileExpertRepo {

  // Instance of Firestore service
  final GetFromFirestore _getFromFirestore = GetFromFirestore();
  final UpdateInFirestore _updateInFirestore = UpdateInFirestore();
  final DeleteFromFirestore _deleteFromFirestore = DeleteFromFirestore();
  final SharedPreferenceServices _sharedPreferenceServices = SharedPreferenceServices();
  final FirebaseAuthentication _firebaseAuthentication = FirebaseAuthentication();
  final EventTypes _eventTypes = EventTypes();
  final DateAndTimeConvertors _dateAndTimeConvertors = DateAndTimeConvertors();
  final EmailNotificationService _emailNotificationService = EmailNotificationService();

  @override
  // Fetches expert profile details from Firestore
  Future<ExpertEntity> fetchExpertProfile() async {
    ExpertModel expertModel = await  _getFromFirestore.getExpertProfileDetails();

    ExpertEntity expertEntity = ExpertEntity(
        uniqueId: expertModel.uniqueId,
        name: expertModel.name,
        minutes: expertModel.minutes,
        topics: expertModel.topics,
        intro: expertModel.intro,
        location: expertModel.location,
        experience: expertModel.experience,
        imageId: expertModel.imageId,
        imageFile: expertModel.imageFile,
        status: expertModel.status,
        isExpert: expertModel.isExpert,
        achievements: expertModel.achievements,
        languages: expertModel.languages
    );

    return expertEntity;
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
  Future<void> assignStatus(String status) async {
    _sharedPreferenceServices.setValue("online", status == "online");

    Map<String, dynamic> data = {"status": status};
    bool response = await _updateInFirestore.updateExpertBasics(data);

    if (response) {
      _updateInFirestore.updateStatusIntoTopic(status);
    }
  }


  @override
  Future<void> saveOnline(String storage, String status) async {
    if (storage == "online") {
      _sharedPreferenceServices.setValue(storage, status == "online");
    } else {
      _sharedPreferenceServices.setValue(storage, true);
    }
  }


  @override
  Future<bool> isOnline() async {
    // Retrieves the 'online' status as a boolean
    bool isOnline = await _getFromFirestore.getStatus();
    return isOnline;
  }


  @override
  Future<bool> checkMeetingsForProfile() async {
    final attendees = _getFromFirestore.getBookings('attendeeId');
    final expertSessions = _getFromFirestore.getBookings('expertId');

    final results = await Future.wait([attendees, expertSessions]);

    BookedModel attendeeBookings = results[0];
    BookedModel expertBookings = results[1];

    List<BookingEntity> combinedEntity = [
      ...attendeeBookings.bookingSessions,
      ...expertBookings.bookingSessions
    ];

    // Remove completed or past meetings
    combinedEntity.removeWhere((b) =>
    b.meetingStatus == "finished" || _dateAndTimeConvertors.compareUtc(b.start)
    );

    return combinedEntity.isEmpty;
  }



  @override
  Future<bool> deleteProfile(Map<String, List> deleteMap) async {
    List<Future<bool>> futures = [];

    // Delete all topic documents
    if (deleteMap["topics"]?.isNotEmpty ?? false) {
      for (var topic in deleteMap["topics"]!) {
        futures.add(_deleteFromFirestore.deleteEvent(topic));
      }
    }

    // Delete all session documents
    if (deleteMap["sessions"]?.isNotEmpty ?? false) {
      for (String session in deleteMap["sessions"]!) {
        if(session.isNotEmpty) {
          futures.add(_deleteFromFirestore.deleteSession(session));
        }
      }
    }

    // Delete expert and user profile + Firebase account
    futures.add(_deleteFromFirestore.deleteExpertProfile());
    futures.add(_deleteFromFirestore.deleteUserProfile());
    futures.add(_firebaseAuthentication.deleteFirebaseUser());

    final responses = await Future.wait(futures);

    // Delete linked calendar events if present
    List<Future<Results>> calFutures = [];
    if (deleteMap["cal"]?.isNotEmpty ?? false) {
      for (var cal in deleteMap["cal"]!) {
        calFutures.add(_eventTypes.deleteEvent(int.parse(cal)));
      }
    }
    await Future.wait(calFutures);

    _sharedPreferenceServices.setValue("loggedIn", false);

    // Returns true if at least one item was successfully deleted
    return responses.contains(true);
  }

  @override
  // Logs the user out by calling the signOut method from Firebase authentication
  Future<bool> logOut() {
    return _firebaseAuthentication.signOut();
  }

  @override
  // Saves the login status locally by setting 'loggedIn' to false in shared preferences
  void localLoginSave() {
    _sharedPreferenceServices.setValue("loggedIn", false);
  }


  @override
  Future<bool> deleteUserProfile() async {
    final userProfile = _deleteFromFirestore.deleteUserProfile();
    final userAuth = _firebaseAuthentication.deleteFirebaseUser();

    final responses = await Future.wait([userProfile, userAuth]);

    _sharedPreferenceServices.setValue("loggedIn", false);
    return responses.contains(true);
  }


  @override
  Future<String> getOfficialPhone() async {
    return _getFromFirestore.getOfficialPhone();
  }


  @override
  Future<Results> sendSubscriptionMail(SubscriptionMailEntity subscriptionMailEntity) {

    SubscriptionMailModel subscriptionMailModel = SubscriptionMailModel(
        id: subscriptionMailEntity.id,
        event: subscriptionMailEntity.event,
        level: subscriptionMailEntity.level,
        section: subscriptionMailEntity.section,
        currentLevel: subscriptionMailEntity.currentLevel
    );

    return _emailNotificationService.sendEmail(subscriptionMailModel.toJson());
  }

}
