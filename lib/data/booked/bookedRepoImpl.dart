import 'package:reachx_embed/data/booked/bookedModel.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/saveInFirestore.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/updateInFireStore.dart';
import 'package:reachx_embed/data/models/ratingModel.dart';
import 'package:reachx_embed/data/models/bookingModel.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/getFromFireStore.dart';
import 'package:reachx_embed/data/models/expertsModel.dart';
import 'package:reachx_embed/domain/booked/bookedEntity.dart';
import 'package:reachx_embed/domain/booked/bookedRepo.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/ratingEntity.dart';
import 'package:uuid/uuid.dart';

class BookedRepoImpl implements BookedRepo {
  // Firestore and service class instances
  final GetFromFirestore _getFromFirestore = GetFromFirestore();
  final UpdateInFirestore _updateInFirestore = UpdateInFirestore();
  final SaveInFirestore _saveInFirestore = SaveInFirestore();
  final FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();

  Map<String, dynamic> data = {};

  /// Fetch all bookings (attendee or expert) and convert them to entities
  @override
  Future<BookedEntity> getBookings(String dbName) async {
    bool flag = false;
    String date = "not-given";
    String userId = await FirebaseAuthentication().getFirebaseUid() ?? '';

    BookedModel bookedModel = await _getFromFirestore.getBookings(dbName);

    // Convert each booking to BookingEntity and check reschedule initiator
    List<BookingEntity> bookingList = await Future.wait(
      bookedModel.bookingSessions.map((booking) async {
        if (booking.rescheduleStatus == "ongoing") {
          RescheduleModel rescheduleModel = await _getFromFirestore.getRescheduleInitiatorId(booking.rescheduleId!);
          if (rescheduleModel.rescheduleInitiatorId == userId) {
            flag = true;
          }
        }

        return BookingEntity(
          start: booking.start,
          expertName: booking.expertName,
          topicId: booking.topicId,
          eventId: booking.eventId,
          expertId: booking.expertId,
          bookingId: booking.bookingId,
          bookingUniqueId: booking.bookingUniqueId,
          eventName: booking.eventName,
          description: booking.description,
          lengthInMinutes: booking.lengthInMinutes,
          attendeeId: booking.attendeeId,
          meetingUrl: booking.meetingUrl,
          meetingStatus: booking.meetingStatus,
          rate: booking.rate,
          sessionType: booking.sessionType,
          rescheduleStatus: booking.rescheduleStatus,
          rescheduleId: booking.rescheduleId,
          rescheduleInitiator: flag,
          rescheduleDate: date,
          reviewRating: booking.reviewRating,
          location: booking.location,
          attendee: AttendeeModel(
            name: booking.attendee.name,
            timeZone: booking.attendee.timeZone,
          ),
          session: booking.session,
        );
      }),
    );

    // Sort bookings by start time
    bookingList.sort((a, b) => DateTime.parse(a.start).compareTo(DateTime.parse(b.start)));

    return BookedEntity(bookingSessions: bookingList);
  }

  /// Save rating and update expert + topic ratings accordingly
  @override
  Future<bool> saveRating(RatingEntity ratingEntity, double newRating, int count, String uniqueId) async {
    RatingModel ratingModel = RatingModel(
      uniqueId: ratingEntity.uniqueId,
      rating: ratingEntity.rating,
      review: ratingEntity.review,
    );

    String ratingId = '${DateTime.now()} ${const Uuid().v4()}';
    bool response = await _saveInFirestore.saveRating(ratingModel, ratingId);

    if (response) {
      List topicIds = await _updateInFirestore.updateRating(count, newRating, uniqueId);

      final futures = topicIds.map((id) => _updateInFirestore.updateRatingInTopics(count, newRating, id)).toList();
      final results = await Future.wait(futures);

      return !results.contains(false);
    }

    return false;
  }

  /// Fetch expert details and convert to domain entity
  @override
  Future<ExpertEntity> getExpertDetails(String expertId) async {
    ExpertModel expertModel = await _getFromFirestore.getExpertDetails(expertId);

    return ExpertEntity(
      uniqueId: expertModel.uniqueId,
      name: expertModel.name,
      minutes: expertModel.minutes,
      topics: expertModel.topics,
      intro: expertModel.intro,
      location: expertModel.location,
      experience: expertModel.experience,
      count: expertModel.count,
      rating: expertModel.rating,
      languages: expertModel.languages,
      achievements: expertModel.achievements,
      imageFile: ''
    );
  }

  /// Update a booking with a new review rating
  @override
  void updateBookingRated(String bookingId, double rating) async {
    data = {
      "reviewRating": rating,
    };
    _updateInFirestore.updateBooking(bookingId, data);
  }


  @override
  Future<RescheduleEntity> getRescheduleData(String rescheduleId) async {
    RescheduleModel rescheduleModel = await _getFromFirestore.getRescheduleInitiatorId(rescheduleId);

    RescheduleEntity rescheduleEntity = RescheduleModel(
        rescheduleProgress: rescheduleModel.rescheduleProgress,
        rescheduleInitiatorId: rescheduleModel.rescheduleInitiatorId,
        bookingId: rescheduleModel.bookingId,
        timestamp: rescheduleModel.timestamp
    );

    return rescheduleEntity;
  }
}

