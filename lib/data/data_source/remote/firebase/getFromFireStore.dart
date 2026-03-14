import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:reachx_embed/core/constants/enums.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/booked/bookedModel.dart';
import 'package:reachx_embed/data/models/bookingModel.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/data/homescreen/homeScreenModel.dart';
import 'package:reachx_embed/data/models/coinsModel.dart';
import 'package:reachx_embed/data/models/expertsModel.dart';
import 'package:reachx_embed/data/models/institutionModel.dart';
import 'package:reachx_embed/data/models/momentModel.dart';
import 'package:reachx_embed/data/models/requestModel.dart';
import 'package:reachx_embed/data/models/sessionModel.dart';
import 'package:reachx_embed/data/models/streakModel.dart';
import 'package:reachx_embed/data/models/subscriptionModel.dart';
import 'package:reachx_embed/data/models/topicModel.dart';
import 'package:reachx_embed/data/models/transactionModel.dart';
import 'package:reachx_embed/data/models/userModel.dart';
import 'package:reachx_embed/data/models/walletModel.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';

class GetFromFirestore {
  FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();
  String? userId;


  Future<String> getOfficialPhone() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(FirebaseCollection.app_inputs.name);
    try {
      DocumentSnapshot snapshot = await users.doc("number").get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return data["official_no"];
      }
      return '';
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<HomeScreenModel> getTutorials() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(FirebaseCollection.app_inputs.name);
    try {
      DocumentSnapshot snapshot = await users.doc("tutorial_links").get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return HomeScreenModel.fromFirestore(data);
      }
      return HomeScreenModel(links: {}, length: 0);
    } catch (e) {
      print(e);
      return HomeScreenModel(links: {}, length: 0);
    }
  }

  Future<int> getPaymentCharge() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(FirebaseCollection.app_inputs.name);
    try {
      DocumentSnapshot snapshot = await users.doc("payment").get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return data["charge"];
      }
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<bool> getStatus() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(FirebaseCollection.experts.name);
    try {
      userId = await firebaseAuthentication.getFirebaseUid();
      if (userId != null) {
        DocumentSnapshot snapshot = await users.doc(userId).get();
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          if (data["status"] == "online") {
            return true;
          } else {
            return false;
          }
        }
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<ExpertModel> getExpertDetails(String uniqueId) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(FirebaseCollection.experts.name);
    try {
      DocumentSnapshot snapshot = await users.doc(uniqueId).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return ExpertModel.fromJson(data);
      }
      return ExpertModel(
          uniqueId: '',
          name: '',
          minutes: 60,
          experience: 0,
          location: "unknown",
          topics: [],
          intro: '',
          review: '',
          rating: 0,
          count: 0,
          languages: [],
          achievements: [],
          imageFile: ''
      );
    } catch (e) {
      print(e);
      return ExpertModel(
          uniqueId: '',
          name: '',
          minutes: 60,
          experience: 0,
          location: "unknown",
          topics: [],
          intro: '',
          review: '',
          rating: 0,
          count: 0,
          languages: [],
          achievements: [],
          imageFile: ''
      );
    }
  }

  Future<TopicsModel> getSearchTopics(
      {String type = '', String searchQuery = ''}) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection(FirebaseCollection.topics.name);
    userId = await firebaseAuthentication.getFirebaseUid();
    try {
      QuerySnapshot querySnapshot;
      if (searchQuery.isNotEmpty) {
        querySnapshot =
            await collection.where("name", isEqualTo: searchQuery).get();
      } else {
        querySnapshot = await collection.get();
      }
      if (querySnapshot.docs.isNotEmpty) {
        return TopicsModel.fromJson(querySnapshot.docs);
      }
      return TopicsModel(topics: []);
    } catch (e) {
      print("failed, $e");
      return TopicsModel(topics: []);
    }
  }

  Future<TopicModel> getTopic({String id = ''}) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection(FirebaseCollection.topics.name);
    userId = await firebaseAuthentication.getFirebaseUid();
    try {
      QuerySnapshot querySnapshot;
      querySnapshot = await collection.where("topicId", isEqualTo: id).get();
      if (querySnapshot.docs.isNotEmpty) {
        return TopicModel.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
      }
      return TopicModel(
          expertId: '',
          name: '',
          description: '',
          session: '',
          sessionType: '',
          topicRate: 0,
          expertName: '',
          sessionId: '',
          availability: false,
          topicId: '');
    } catch (e) {
      print("failed");
      return TopicModel(
          expertId: '',
          name: '',
          description: '',
          session: '',
          sessionType: '',
          topicRate: 0,
          expertName: '',
          sessionId: '',
          availability: false,
          topicId: '');
    }
  }

  Future<MomentModel> getMoments(String momentId) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection(FirebaseCollection.moments.name);
    try {
      DocumentSnapshot snapshot = await collection.doc(momentId).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return MomentModel.fromJson(data);
      }
      return MomentModel(
          momentId: '',
          selectedImage: '',
          description: '',
          date: DateTime.now(),
          timestamp: DateTime.now().subtract(const Duration(days: 1))
      );
    } catch (e) {
      debugPrint("failed, $e");
      return MomentModel(
          momentId: '',
          selectedImage: '',
          description: '',
          date: DateTime.now(),
          timestamp: DateTime.now().subtract(const Duration(days: 1))
      );
    }
  }

  Future<ExpertModel> getExpertProfileDetails() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(FirebaseCollection.experts.name);
    userId = await firebaseAuthentication.getFirebaseUid();
    try {
      if (userId != null) {
        // Fetch the document from Firestore
        DocumentSnapshot snapshot = await users.doc(userId).get();
        // Check if the document exists and parse its data
        if (snapshot.exists) {
          // Cast data to Map and extract the list
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          return ExpertModel.fromJson(data);
        }
        // Return an empty InterestsModel if the document does not exist
        return ExpertModel(
            uniqueId: '',
            name: '',
            minutes: 60,
            experience: 0,
            location: "unknown",
            topics: [],
            intro: '',
            languages: [],
            achievements: [],
            imageFile: ''
        );
      }
      return ExpertModel(
          uniqueId: '',
          name: '',
          minutes: 60,
          experience: 0,
          location: "unknown",
          topics: [],
          intro: '',
          languages: [],
          achievements: [],
          imageFile: ''
      );
    } catch (e) {
      print(e);
      return ExpertModel(
          uniqueId: '',
          name: '',
          minutes: 60,
          experience: 0,
          location: "unknown",
          topics: [],
          intro: '',
          languages: [],
          achievements: [],
          imageFile: ''
      );
    }
  }


  Future<UserModel> getUserProfileDetails() async {
    CollectionReference users = FirebaseFirestore.instance.collection(FirebaseCollection.users.name);
    userId = await firebaseAuthentication.getFirebaseUid();
    try {
      if (userId != null) {
        // Fetch the document from Firestore
        DocumentSnapshot snapshot = await users.doc(userId).get();
        // Check if the document exists and parse its data
        if (snapshot.exists) {
          // Cast data to Map and extract the list
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          return UserModel.fromJson(data);
        }
        // Return an empty InterestsModel if the document does not exist
        return UserModel(name: '', phoneNo: '', email: '', subscriptionStatus: 'beginner');
      }
      return UserModel(name: '', phoneNo: '', email: '', subscriptionStatus: 'beginner');
    } catch (e) {
      print(e);
      return UserModel(name: '', phoneNo: '', email: '', subscriptionStatus: 'beginner');
    }
  }

  Future<UserModel> getUserDetails(String userId) async {
    CollectionReference users = FirebaseFirestore.instance.collection(FirebaseCollection.users.name);
    try {
      // Fetch the document from Firestore
      DocumentSnapshot snapshot = await users.doc(userId).get();
      // Check if the document exists and parse its data
      if (snapshot.exists) {
        // Cast data to Map and extract the list
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return UserModel.fromJson(data);
      }
      return UserModel(name: '', phoneNo: '', email: '', fcmToken: '', subscriptionStatus: 'beginner');
    } catch (e) {
      print(e);
      return UserModel(name: '', phoneNo: '', email: '', fcmToken: '', subscriptionStatus: 'beginner');
    }
  }

  Future<UserModel> getLoginUser(String phoneNo) async {
    CollectionReference users = FirebaseFirestore.instance.collection(FirebaseCollection.users.name);
    try {
      QuerySnapshot snapshot =
          await users.where("phone", isEqualTo: phoneNo).get();
      // Check if the document exists and parse its data
      if (snapshot.docs.isNotEmpty) {
        UserModel user = UserModel.fromJson(
            snapshot.docs.first.data() as Map<String, dynamic>);
        return user;
      }
      // Return an empty InterestsModel if the document does not exist
      return UserModel(name: '', phoneNo: '', email: '', subscriptionStatus: 'beginner');
    } catch (e) {
      print(e);
      return UserModel(name: '', phoneNo: '', email: '', subscriptionStatus: 'beginner');
    }
  }

  Future<String> getUserId(String data, bool isPhone) async {
    CollectionReference users = FirebaseFirestore.instance.collection(FirebaseCollection.users.name);
    try {
      late QuerySnapshot snapshot;

      if (isPhone) {
        snapshot = await users.where("phone", isEqualTo: data).get();
      } else {
        snapshot = await users.where("email", isEqualTo: data).get();
      }
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id;
      }
      return '';
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<BookedModel> getBookings(String dbName) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(FirebaseCollection.booking.name);
    userId = await FirebaseAuthentication().getFirebaseUid();
    try {
      if (userId != null) {
        // Fetch the document from Firestore
        QuerySnapshot snapshot =
            await users.where(dbName, isEqualTo: userId).get();
        if (snapshot.docs.isNotEmpty) {
          List<BookingStorageModel> bookings = snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return BookingStorageModel.fromJson(data);
          }).toList();
          return BookedModel(bookingSessions: bookings);
        }
      }
      // Return an empty InterestsModel if the document does not exist
      return BookedModel(bookingSessions: []);
    } catch (e) {
      print(e);
      return BookedModel(bookingSessions: []);
    }
  }

  Future<BookedModel> getAllBookings() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(FirebaseCollection.booking.name);
    try {
      QuerySnapshot snapshot = await collectionReference.get();
      if (snapshot.docs.isNotEmpty) {
        List<BookingStorageModel> bookings = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return BookingStorageModel.fromJson(data);
        }).toList();
        return BookedModel(bookingSessions: bookings);
      }
      // Return an empty InterestsModel if the document does not exist
      return BookedModel(bookingSessions: []);
    } catch (e) {
      print(e);
      return BookedModel(bookingSessions: []);
    }
  }

  Future<BookingStorageModel> getMeetingDetails(String bookingId) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(FirebaseCollection.booking.name);
    userId = await FirebaseAuthentication().getFirebaseUid();
    try {
      if (userId != null) {
        // Fetch the document from Firestore
        QuerySnapshot snapshot =
            await users.where("bookingUniqueId", isEqualTo: bookingId).get();
        if (snapshot.docs.isNotEmpty) {
          return BookingStorageModel.fromJson(
              snapshot.docs.first.data() as Map<String, dynamic>);
        }
      }
      // Return an empty InterestsModel if the document does not exist
      return BookingStorageModel(
          start: "",
          topicId: '',
          attendee: Attendee(name: '', timeZone: ''),
          eventName: '',
          selectedDate: '',
          eventId: 0);
    } catch (e) {
      print(e);
      return BookingStorageModel(
          start: "",
          topicId: '',
          attendee: Attendee(name: '', timeZone: ''),
          eventName: '',
          selectedDate: '',
          eventId: 0);
    }
  }

  Future<RescheduleModel> getRescheduleInitiatorId(String rescheduleId) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(FirebaseCollection.reschedules.name);
    try {
      // Fetch the document from Firestore
      DocumentSnapshot snapshot = await users.doc(rescheduleId).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        return RescheduleModel.fromJson(data);
      }
      // Return an empty InterestsModel if the document does not exist
      return RescheduleModel(
          rescheduleProgress: '',
          rescheduleInitiatorId: '',
          bookingId: '',
          timestamp: null);
    } catch (e) {
      print(e);
      return RescheduleModel(
          rescheduleProgress: '',
          rescheduleInitiatorId: '',
          bookingId: '',
          timestamp: null);
    }
  }

  Future<PopularCategoryModel> getPopularTopics() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(FirebaseCollection.app_inputs.name);
    try {
      // Fetch the document from Firestore
      DocumentSnapshot snapshot = await users.doc("stack1").get();
      // Check if the document exists and parse its data
      if (snapshot.exists) {
        // Cast data to Map and extract the list
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return PopularCategoryModel.fromFirestore(data);
      }
      // Return an empty InterestsModel if the document does not exist
      return PopularCategoryModel(categories: []);
    } catch (e) {
      print(e);
      return PopularCategoryModel(categories: []);
    }
  }

  Future<List<String>> getAllIds(String collectionName) async {
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection(collectionName);

      QuerySnapshot querySnapshot = await collectionReference.get();

      List<String> docIds = querySnapshot.docs.map((doc) => doc.id).toList();

      return docIds;
    } catch (e) {
      print("Error fetching document IDs: $e");
      return [];
    }
  }

  Future<SessionModel> getSessionDetail(String uniqueId) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection(FirebaseCollection.sessions.name);
    try {
      // Fetch the document from Firestore
      DocumentSnapshot snapshot = await users.doc(uniqueId).get();
      // Check if the document exists and parse its data
      if (snapshot.exists) {
        // Cast data to Map and extract the list
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return SessionModel.fromJson(data);
      }
      // Return an empty InterestsModel if the document does not exist
      return SessionModel(
          session: '',
          sessionType: '',
          sessionId: '',
          eventId: 0,
          scheduleId: 0);
    } catch (e) {
      print(e);
      return SessionModel(
          session: '',
          sessionType: '',
          sessionId: '',
          eventId: 0,
          scheduleId: 0);
    }
  }

  Future<TransactionsModel> getProfileTransactionDetails() async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection(FirebaseCollection.transactions.name);

      final userId = await firebaseAuthentication.getFirebaseUid();

      if (userId != null) {
        QuerySnapshot querySnapshot = await collection
            .where("transactionIds", arrayContains: userId)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          return TransactionsModel.fromJson(querySnapshot.docs);
        }
      }
      return TransactionsModel(transactions: []);
    } catch (e) {
      print("Error fetching document IDs: $e");
      return TransactionsModel(transactions: []);
    }
  }

  Future<WalletModel> getBalance(String userId) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection(FirebaseCollection.wallet.name);
      DocumentSnapshot documentSnapshot = await collection.doc(userId).get();
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        return WalletModel.fromJson(data);
      }
      return WalletModel(walletBalance: 0, walletId: '', currencySymbol: '');
    } catch (e) {
      print("Error fetching document IDs: $e");
      return WalletModel(walletBalance: 0, walletId: '', currencySymbol: '');
    }
  }

  Future<Map<String, dynamic>> getConversionRate(String typeId) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection(FirebaseCollection.app_inputs.name);
      DocumentSnapshot documentSnapshot =
          await collection.doc("conversion_rates").get();

      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>;
      }
      return {};
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Results> getCouponTokens() async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection(FirebaseCollection.app_inputs.name);
      DocumentSnapshot documentSnapshot =
          await collection.doc("token_coupons").get();

      if (documentSnapshot.exists) {
        return Results.success(documentSnapshot.data() as Map<String, dynamic>);
      }
      return Results.error("");
    } catch (e) {
      print(e);
      return Results.error("");
    }
  }

  Future<Results> getSerialNumber() async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection(FirebaseCollection.app_inputs.name);
      DocumentSnapshot documentSnapshot =
          await collection.doc("payment_no").get();

      if (documentSnapshot.exists) {
        return Results.success(documentSnapshot.data() as Map<String, dynamic>);
      }
      return Results.error("");
    } catch (e) {
      print(e);
      return Results.error("");
    }
  }

  Future<Results> getRequests() async {
    try {
      userId = await firebaseAuthentication.getFirebaseUid();

      CollectionReference collection =
          FirebaseFirestore.instance.collection(FirebaseCollection.requests.name);
      QuerySnapshot snapshot =
          await collection.where("expertId", isEqualTo: userId).get();

      if (snapshot.docs.isNotEmpty) {
        return Results.success(MultipleRequestsModel.fromJson(snapshot.docs));
      }
      return Results.error("");
    } catch (e) {
      print(e);
      return Results.error("");
    }
  }


  Future<Results> fetchStreaks(String passionId) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection(FirebaseCollection.passion_streak.name);

      DocumentSnapshot snapshot = await collection.doc(passionId).get();

      if (snapshot.exists) {
        return Results.success(
            StreakModel.fromJson(snapshot.data() as Map<String, dynamic>));
      }

      return Results.error("No data found");
    } catch (e) {
      debugPrint(e.toString());
      return Results.error(e);
    }
  }

  Future<TopicsModel> getExpertPassions(String expertId) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection(FirebaseCollection.topics.name);
    userId = await firebaseAuthentication.getFirebaseUid();
    try {
      QuerySnapshot querySnapshot;
      querySnapshot = await collection
          .where("expertId", isEqualTo: expertId)
          .where("skillType", isEqualTo: "lifeSkill")
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return TopicsModel.fromJson(querySnapshot.docs);
      }
      return TopicsModel(topics: []);
    } catch (e) {
      print("failed, $e");
      return TopicsModel(topics: []);
    }
  }

  Future<TopicsModel> getExpertTopics(String expertId) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection(FirebaseCollection.topics.name);
    userId = await firebaseAuthentication.getFirebaseUid();
    try {
      QuerySnapshot querySnapshot;
      querySnapshot =
          await collection.where("expertId", isEqualTo: expertId).get();
      if (querySnapshot.docs.isNotEmpty) {
        return TopicsModel.fromJson(querySnapshot.docs);
      }
      return TopicsModel(topics: []);
    } catch (e) {
      print("failed, $e");
      return TopicsModel(topics: []);
    }
  }


  Future<Results> fetchCoins() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection(FirebaseCollection.coins.name);
    userId = await firebaseAuthentication.getFirebaseUid();
    try {
      if (userId != null) {
        DocumentSnapshot snapshot = await collection.doc(userId).get();
        if (snapshot.exists) {
          return Results.success(
              CoinsModel.fromJson(snapshot.data() as Map<String, dynamic>));
        } else {
          return Results.success(
              CoinsModel(totalBalance: 0, currentBalance: 0, userId: userId));
        }
      }
      return Results.error("User Id not found");
    } catch (e) {
      return Results.error("Unknown error");
    }
  }


  Future<Results> getSubscriptionTest() async {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection(
          FirebaseCollection.subscriptionTest.name);
      final QuerySnapshot snapshot = await collection.get();

      if (snapshot.docs.isEmpty) {
        return Results.error("No data found");
      }

      return Results.success(
        SubscriptionModel.fromJson(snapshot.docs)
      );
    } catch (e) {
      print("failed, $e");
      return Results.error("Unknown error: $e");
    }
  }


  Future<Results> fetchInstitution(String institutionId) async {
    CollectionReference collection =
    FirebaseFirestore.instance.collection(FirebaseCollection.institutions.name);
    try {
      DocumentSnapshot snapshot = await collection.doc(institutionId).get();
      if (snapshot.exists) {
        return Results.success(InstitutionModel.fromJson(snapshot.data() as Map<String, dynamic>));
      } else {
        return Results.error("Not found");
      }
    } catch (e) {
      return Results.error("Unknown error");
    }
  }
}
