import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reachx_embed/core/constants/enums.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';

/// Service to fetch data from Firestore
class DeleteFromFirestore {

  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();

  String? userId;

  Future<bool> deleteBooking(String bookingUniqueId) async {

    CollectionReference users = FirebaseFirestore.instance.collection(FirebaseCollection.booking.name);

    try {
      // Fetch the document from Firestore
      QuerySnapshot querySnapshot = await users.where("bookingUniqueId", isEqualTo: bookingUniqueId).get();

      if(querySnapshot.docs.isEmpty) {
        return false;
      }

      for(QueryDocumentSnapshot doc in querySnapshot.docs) {
        await users.doc(doc.id).delete();
      }
      // Return an empty InterestsModel if the document does not exist
      return true;
    }catch (e) {
      print(e);
      return false;
    }

  }


  /// Deletes an event from the 'topics' collection by eventId.
  Future<bool> deleteEvent(String eventId) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.topics.name);
      await collection.doc(eventId).delete();
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }

  Future<Results> deleteMoment(String momentId) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.moments.name);
      await collection.doc(momentId).delete();
      return Results.success(true);
    } catch(e) {
      print(e);
      return Results.error(false);
    }
  }


  Future<bool> deleteExpertTopic(String eventId) async {
    try {
      final String? userId = await firebaseAuthentication.getFirebaseUid();
      if (userId == null) return false;
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.experts.name);
      await collection.doc(userId).update({
        'topics': FieldValue.arrayRemove([eventId]),
      });
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }

  Future<Results> deleteTopicMoment(String eventId, String momentId) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.topics.name);
      await collection.doc(eventId).update({
        'momentsIds': FieldValue.arrayRemove([momentId]),
      });
      return Results.success(true);
    } catch(e) {
      print(e);
      return Results.error(false);
    }
  }

  /// Adds a topic eventId to the 'topics' array of an expert document.
  Future<bool> deleteSession(String uniqueId) async {
    try {
      final String? userId = await firebaseAuthentication.getFirebaseUid();
      if (userId == null) return false;
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.sessions.name);
      await collection.doc(uniqueId).delete();
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }




  Future<bool> deleteTransaction(int bookingId) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.payments.name);
      QuerySnapshot querySnapshot = await collection.where('bookingId', isEqualTo: bookingId).get();

      if(querySnapshot.docs.isEmpty) {
        return false;
      }

      QueryDocumentSnapshot queryDocumentSnapshot = querySnapshot.docs.first;
      await collection.doc(queryDocumentSnapshot.id).delete();

      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }



  Future<bool> deleteRescheduleData(String rescheduleId) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.reschedules.name);
      await collection.doc(rescheduleId).delete();
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }


  Future<bool> deleteRequestData(String requestId) async {
    try {
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.requests.name);
      await collection.doc(requestId).delete();
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }


  /// Deletes an event from the 'topics' collection by eventId.
  Future<bool> deleteExpertProfile() async {
    try {
      userId = await firebaseAuthentication.getFirebaseUid();
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.experts.name);
      await collection.doc(userId).delete();
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }


  Future<bool> deleteUserProfile() async {
    try {
      userId = await firebaseAuthentication.getFirebaseUid();
      final CollectionReference collection = FirebaseFirestore.instance.collection(FirebaseCollection.users.name);
      await collection.doc(userId).delete();
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }
}