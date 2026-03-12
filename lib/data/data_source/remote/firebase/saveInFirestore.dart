import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reachx_embed/core/constants/enums.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/booked/bookedModel.dart';
import 'package:reachx_embed/data/meetingSetup/meetingSetupModel.dart';
import 'package:reachx_embed/data/models/ratingModel.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/data/models/expertsModel.dart';
import 'package:reachx_embed/data/models/momentModel.dart';
import 'package:reachx_embed/data/models/requestModel.dart';
import 'package:reachx_embed/data/models/sessionModel.dart';
import 'package:reachx_embed/data/models/streakModel.dart';
import 'package:reachx_embed/data/models/topicModel.dart';
import 'package:reachx_embed/data/models/transactionModel.dart';
import 'package:reachx_embed/data/models/userModel.dart';
import 'package:reachx_embed/data/models/viewCountModel.dart';
import 'package:reachx_embed/data/models/walletModel.dart';
import 'package:reachx_embed/data/passionGenerator/passionGeneratorModel.dart';
import 'package:uuid/uuid.dart';

class SaveInFirestore {
  final FirebaseAuthentication _firebaseAuthentication = FirebaseAuthentication();

  Future<bool> saveUser(UserModel userModel) async {
    return _saveData(
      collectionName: FirebaseCollection.users.name,
      data: userModel.toJson(),
    );
  }

  Future<bool> saveExpertDetails(ExpertModel expertRegistrationModel) async {
    return _saveData(
      collectionName: FirebaseCollection.experts.name,
      data: expertRegistrationModel.toJson(),
    );
  }


  Future<bool> saveProfileViewCount(ViewCountModel viewCountModel) async {
    try {

      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.profile_view_count.name);
      await collection.doc(viewCountModel.viewCountId).set(viewCountModel.toJson());

      return true;
    } catch(e) {
      print('Unexpected error: $e');
      return false;
    }
  }


  Future<bool> saveTopics(TopicModel topicModel,String topicId, {BuildContext? context}) async {
    try {

      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.topics.name);
      await collection.doc(topicId).set(topicModel.toJson());

      return true;
    } catch(e) {
      print("Topic save unsuccessful");
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save topic: $e'))
        );
      }
      return false;
    }
  }

  Future<Results> saveMoments(String momentId, MomentModel momentModel) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.moments.name);
      await collection.doc(momentId).set(momentModel.toJson());
      return Results.success(true);
    } catch(e) {
      print("Topic save unsuccessful");
      return Results.error(null);
    }
  }

  Future<bool> saveSessions(SessionModel sessionModel) async {
    try {

      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.sessions.name);
      await collection.doc(sessionModel.sessionId).set(sessionModel.toJson());
      return true;
    } catch(e) {
      print("Session save unsuccessful");
      return false;
    }
  }

  Future<bool> saveBookingDetails(String id, {required var bookingModel}) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.booking.name);
      await collection.doc(id).set(bookingModel.toJson());
      return true;
    } catch (e) {
      print("Error saving data to booking : $e");
      return false;
    }
  }


  Future<String> saveRescheduleDetails({
    required RescheduleModel rescheduleModel
  }) async {
    var id = const Uuid().v4();
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.reschedules.name);
      await collection.doc(id).set(rescheduleModel.toJson());
      return id;
    } catch (e) {
      print("Error saving data to booking : $e");
      return '';
    }
  }

  /// Saves expert details in the Firestore `experts` collection.
  Future<bool> saveExpertEdit(Map<String, dynamic> data) async {
    return _saveData(
      collectionName: FirebaseCollection.experts.name,
      data: data,
    );
  }

  Future<Results> saveWallet(WalletModel walletModel) async {
    bool response = await  _saveData(
        collectionName: FirebaseCollection.wallet.name,
        data: walletModel.toJson()
    );

    if(response) {
      return Results.success(walletModel.walletId);
    } else {
      return Results.error("Unsuccessful");
    }
  }

  /// Generic function to save data in Firestore.
  Future<bool> _saveData({
    required String collectionName,
    required Map<String, dynamic> data,
  }) async {
    try {
      final String? userId = await _firebaseAuthentication.getFirebaseUid();
      if (userId == null) return false;

      final CollectionReference collection =
      FirebaseFirestore.instance.collection(collectionName);
      await collection.doc(userId).set(data);
      return true;
    } catch (e) {
      return false;
    }
  }


  Future<bool> saveRating(RatingModel ratingModel, String ratingId) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.ratings.name);
      await collection.doc(ratingId).set(ratingModel.toJson());
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }

  Future<bool> saveRequest(RequestModel requestModel, String requestId) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.requests.name);
      await collection.doc(requestId).set(requestModel.toJson());
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }

  Future<bool> saveTransactionDetails({required TransactionModel transactionModel}) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.transactions.name);
      await collection.doc(transactionModel.id).set(transactionModel.toJson());
      return true;
    } catch (e) {
      print("Error saving data to booking : $e");
      return false;
    }
  }

  Future<bool> saveMeetingData({required MeetingSetupModel meetingSetupModel}) async {
    var id = const Uuid().v4();
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.meetings.name);
      await collection.doc(id).set(meetingSetupModel.toJson());
      return true;
    } catch (e) {
      print("Error saving data to booking : $e");
      return false;
    }
  }


  Future<bool> saveSearch(String search) async{
    var id = const Uuid().v4();
    var date = DateTime.now();
    String? userId = await _firebaseAuthentication.getFirebaseUid();
    try {

      Map<String, dynamic> data = {};

      if(userId != null) {
        data = {
          "userId" : userId,
          "dateTime": date,
          "searchItem": search
        };
      } else{
        data = {
          "userId" : id,
          "dateTime": date,
          "searchItem": search
        };
      }

      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.user_searches.name);
      await collection.doc(id).set(data);
      return true;

    } catch (e) {
      print("Error: $e");
      return false;
    }
  }


  Future<Results> saveStreak(StreakModel streakModel) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.passion_streak.name);
      await collection.doc(streakModel.passionId).set(streakModel.toJson());
      return Results.success("Successfully saved");

    } catch(e) {
      debugPrint(e.toString());
      return Results.error(e);
    }
  }

  Future<bool> saveAnswers(String id, {required AnswerSheetModel answerSheetModel}) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.answers.name);
      await collection.doc(id).set(answerSheetModel.toJson());
      return true;
    } catch (e) {
      print("Error saving answer data : $e");
      return false;
    }
  }
}

