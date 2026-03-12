
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:reachx_embed/core/constants/enums.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/data/models/coinsModel.dart';
import 'package:reachx_embed/data/models/expertsModel.dart';
import 'package:reachx_embed/data/models/momentModel.dart';

/// Service for saving user and expert details in Firestore
class UpdateInFirestore {
  final FirebaseAuthentication _firebaseAuthentication = FirebaseAuthentication();

  /// Updates the schedule of an expert with selected time intervals and days.
  Future<bool> upDateSchedule(List selectedTime, List selectedDay) async {
    return _saveData(
      collectionName: FirebaseCollection.experts.name,
      data: {
        "selectedTimeInterval": selectedTime,
        "selectedDays": selectedDay
      },
    );
  }

  Future<bool> updateExpertEdit(Map<String, dynamic> data) async {
    return _saveData(
      collectionName: FirebaseCollection.experts.name,
      data: data,
    );
  }


  /// Generic function to save data in Firestore.
  Future<bool> _saveData({
    required String collectionName,
    required Map<String, dynamic> data,
  }) async {
    try {
      final String? userId = await _firebaseAuthentication.getFirebaseUid();
      if (userId == null) return false;
      final CollectionReference collection = FirebaseFirestore.instance.collection(collectionName);
      final docSnapshot = await collection.doc(userId).get();

      if(docSnapshot.exists) {
        await collection.doc(userId).update(data);
      } else {
        await collection.doc(userId).set(data);
      }

      return true;
    } catch (e) {
      debugPrint('Error updating data to $collectionName: $e');
      return false;
    }
  }


  Future<bool> updateBalance(Map<String, dynamic> data, String userId) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.wallet.name);
      final docSnapshot = await collection.doc(userId).get();

      if(docSnapshot.exists) {
        await collection.doc(userId).update(data);
      } else {
        data["walletId"] = userId;
        await collection.doc(userId).set(data);
      }

      return true;
    } catch (e) {
      debugPrint('Error updating data to wallet: $e');
      return false;
    }
  }

  /// Updates an existing booking document by its unique booking ID.
  Future<bool> updateBooking(String bookingUniqueId, Map<String, dynamic> data) async {
    try {
      final String? userId = await _firebaseAuthentication.getFirebaseUid();
      if (userId == null) return false;
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.booking.name);
      final QuerySnapshot querySnapshot = await collection.where("bookingUniqueId", isEqualTo: bookingUniqueId).limit(1).get();

      if(querySnapshot.docs.isEmpty) {
        debugPrint("No document found with id: $bookingUniqueId");
        return false;
      }

      final String docId = querySnapshot.docs.first.id;

      await collection.doc(docId).update(data);

      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// Updates an event in the 'topics' collection using a TopicModel and eventId.
  Future<bool> updateEvent(Map<String, dynamic> data, String eventId) async {
    try {

      final String? userId = await _firebaseAuthentication.getFirebaseUid();
      if (userId == null) return false;
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.topics.name);
      await collection.doc(eventId).update(data);
      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<Results> updateMoment(MomentModel momentModel) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.moments.name);
      await collection.doc(momentModel.momentId).update(momentModel.toJson());
      return Results.success(true);
    } catch(e) {
      debugPrint(e.toString());
      return Results.error(false);
    }
  }

  /// Updates an event in the 'topics' collection using a TopicModel and eventId.
  Future<bool> updateStatusIntoTopic(String status) async {
    try {
      final String? userId = await _firebaseAuthentication.getFirebaseUid();
      if (userId == null) return false;
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.topics.name);
      final QuerySnapshot querySnapshot = await collection.where("expertId", isEqualTo: userId).get();
      if(querySnapshot.docs.isNotEmpty) {
        for(var doc in querySnapshot.docs) {
          await collection.doc(doc.id).update({
            "status": status
          });
        }
      }
      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> updateNameIntoTopic(String name) async {
    try {
      final String? userId = await _firebaseAuthentication.getFirebaseUid();
      if (userId == null) return false;
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.topics.name);
      final QuerySnapshot querySnapshot = await collection.where("expertId", isEqualTo: userId).get();
      if(querySnapshot.docs.isNotEmpty) {
        for(var doc in querySnapshot.docs) {
          await collection.doc(doc.id).update({
            "expertName": name
          });
        }
      }
      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> updateImageIntoTopic(String imageUrl) async {
    try {
      final String? userId = await _firebaseAuthentication.getFirebaseUid();
      if (userId == null) return false;
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.topics.name);
      final QuerySnapshot querySnapshot = await collection.where("expertId", isEqualTo: userId).get();
      if(querySnapshot.docs.isNotEmpty) {
        for(var doc in querySnapshot.docs) {
          await collection.doc(doc.id).update({
            "imageUrl": imageUrl
          });
        }
      }
      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> updateSessionDetailsIntoTopic(String topicId, Map<String, dynamic> data) async {
    try {
      final String? userId = await _firebaseAuthentication.getFirebaseUid();
      if (userId == null) return false;
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.topics.name);
      await collection.doc(topicId).update(data);
      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> updateLanguagesIntoTopic(List languages) async {
    try {
      final String? userId = await _firebaseAuthentication.getFirebaseUid();
      if (userId == null) return false;
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.topics.name);
      final QuerySnapshot querySnapshot = await collection.where("expertId", isEqualTo: userId).get();
      if(querySnapshot.docs.isNotEmpty) {
        for(var doc in querySnapshot.docs) {
          await collection.doc(doc.id).update({
            "languages": languages
          });
        }
      }
      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// Adds a topic eventId to the 'topics' array of an expert document.
  Future<bool> updateExpertTopic(String eventId) async {
    try {
      final String? userId = await _firebaseAuthentication.getFirebaseUid();
      if (userId == null) return false;
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.experts.name);
      await collection.doc(userId).update({
        'topics': FieldValue.arrayUnion([eventId]),
      });
      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> updateAchievements(String value, String type) async {
    try {
      final String? userId = await _firebaseAuthentication.getFirebaseUid();
      if (userId == null) return false;
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.experts.name);
      if(type == "add") {
        await collection.doc(userId).update({
          'achievements': FieldValue.arrayUnion([value]),
        });
      } else {
        await collection.doc(userId).update({
          'achievements': FieldValue.arrayRemove([value]),
        });
      }
      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<Results> updateTopicMoments(String eventId, String momentId) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.topics.name);
      await collection.doc(eventId).update({
        'momentsIds': FieldValue.arrayUnion([momentId]),
      });
      return Results.success(true);
    } catch(e) {
      debugPrint(e.toString());
      return Results.error(null);
    }
  }


  Future<bool> updateExpertBasics(Map<String, dynamic> data) async {
    try {
      final String? userId = await _firebaseAuthentication.getFirebaseUid();
      if (userId == null) return false;
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.experts.name);
      await collection.doc(userId).update(data);
      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }



  /// Updates an existing booking document by its unique booking ID.
  Future<List> updateRating(int count, double rating, String uniqueId) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance
          .collection(FirebaseCollection.experts.name);
      final QuerySnapshot querySnapshot = await collection.where(
          "uniqueId", isEqualTo: uniqueId).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        ExpertModel expertModel = ExpertModel.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);

        final String docId = querySnapshot.docs.first.id;
        await collection.doc(docId).update({
          "rating": rating,
          "count": count
        });

        return expertModel.topics!;
      }
      return [];
    } catch(e) {
      debugPrint(e.toString());
      return [];
    }
  }


  /// Updates an existing booking document by its unique booking ID.
  Future<bool> updateRatingInTopics(int count, double rating, String topicId) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.topics.name);
      await collection.doc(topicId).update({
        "rating": rating,
        "count": count
      });

      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }


  Future<bool> updateUserDetails(Map<String, dynamic> data) async {
    try {
      final String? userId = await _firebaseAuthentication.getFirebaseUid();
      if (userId == null) return false;
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.users.name);
      await collection.doc(userId).update(data);
      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }



  Future<bool> updateFCMToken(String fcmToken) async {
    final String? userId = await _firebaseAuthentication.getFirebaseUid();
    try {
      if(userId != null) {
        final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.users.name);
        await collection.doc(userId).update({
          "fcmToken": fcmToken
        });
        return true;
      }
      return false;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }


  Future<bool> updateCountInSession(String uniqueId, int slotCount) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.sessions.name);
      await collection.doc(uniqueId).update({
        "groupSlotLeft": slotCount,
      });
      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }


  Future<bool> updatePaymentNo() async {
    try {
      final docRef = FirebaseFirestore.instance.collection(FirebaseCollection.app_inputs.name).doc("payment_no");

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if(!snapshot.exists) throw Exception("Document does not exist");

        final data = snapshot.data() as Map<String, dynamic>;
        final newSerial = (data["serial_no"] ?? 0) + 1;

        transaction.update(docRef, {"serial_no": newSerial});
      });

      return true;
    } catch (e) {
      debugPrint('Error updating data to wallet: $e');
      return false;
    }
  }


  Future<Results> updateStreak(String passionId, Map<String, dynamic> data) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.passion_streak.name);
      await collection.doc(passionId).update(data);
      return Results.success("Successfully updated");


    } catch(e) {
      debugPrint(e.toString());
      return Results.error(e);
    }
  }


  Future<bool> updateUrlIntoBookings(List languages) async {
    try {
      final String? userId = await _firebaseAuthentication.getFirebaseUid();
      if (userId == null) return false;
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.topics.name);
      final QuerySnapshot querySnapshot = await collection.where("expertId", isEqualTo: userId).get();
      if(querySnapshot.docs.isNotEmpty) {
        for(var doc in querySnapshot.docs) {
          await collection.doc(doc.id).update({
            "languages": languages
          });
        }
      }
      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<Results> updateCoins(CoinsModel coinsModel) async {
    try {
      final String? userId = await _firebaseAuthentication.getFirebaseUid();
      if (userId == null) return Results.error("User Id not found");
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.coins.name);
      await collection.doc(userId).set(coinsModel.toJson());
      return Results.success("Successfully updated");
    } catch(e) {
      debugPrint(e.toString());
      return Results.error("Unknown error found: $e");
    }
  }


  Future<bool> updateExpertBadges(String badgeId) async {
    try {
      final String? userId = await _firebaseAuthentication.getFirebaseUid();
      if (userId == null) return false;
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.experts.name);
      await collection.doc(userId).update({
        'badgeId': badgeId,
      });
      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> updateBadgeIntoTopic(String topicId, Map<String, dynamic> data) async {
    try {
      final String? userId = await _firebaseAuthentication.getFirebaseUid();
      if (userId == null) return false;
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.topics.name);
      await collection.doc(topicId).update(data);
      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }


  Future<bool> updateAnswers(String id, Map<String, dynamic> data) async {
    try {
      final String? userId = await _firebaseAuthentication.getFirebaseUid();
      if (userId == null) return false;
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.answers.name);
      await collection.doc(id).update(data);
      return true;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
