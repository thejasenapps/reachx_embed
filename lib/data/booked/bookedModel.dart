import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reachx_embed/data/models/bookingModel.dart';
import 'package:reachx_embed/domain/booked/bookedEntity.dart';

class BookedModel extends BookedEntity {
  // Inherits from BookedEntity and initializes booking sessions
  BookedModel({required super.bookingSessions});


  factory BookedModel.fromJson(dynamic json) {
    List<BookingStorageModel> sessions = List<BookingStorageModel>.from(
      json.map((x) => BookingStorageModel.fromJson(x))
    );

    sessions.sort((b,a) {
        return DateTime.parse(a.start).toUtc().compareTo(DateTime.parse(b.start).toUtc());
      }
    );

    return BookedModel(bookingSessions: sessions);
  }
}




class RescheduleModel extends RescheduleEntity{
  RescheduleModel({
    required super.rescheduleProgress,
    required super.rescheduleInitiatorId,
    required super.bookingId,
    required super.timestamp
  });

  factory RescheduleModel.fromJson(dynamic json) => RescheduleModel(
      rescheduleProgress: json["rescheduleProgress"],
      rescheduleInitiatorId: json["rescheduleInitiatorId"],
      bookingId: json["bookingId"],
      timestamp: (json["timestamp"] as Timestamp).toDate()
  );

  Map<String, dynamic> toJson() => {
    "rescheduleInitiatorId": rescheduleInitiatorId,
    "rescheduleProgress": rescheduleProgress,
    "bookingId": bookingId,
    "timestamp": timestamp ?? DateTime.now()
  };
}
