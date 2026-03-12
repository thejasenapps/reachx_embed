import 'package:reachx_embed/domain/entities/bookingEntity.dart';

class BookedEntity {
  // List of booking sessions for the entity
  List<BookingEntity> bookingSessions;

  // Constructor to initialize the list of booking sessions
  BookedEntity({required this.bookingSessions});
}



class RescheduleEntity {
  String rescheduleProgress;
  String rescheduleInitiatorId;
  String bookingId;
  DateTime? timestamp;

  RescheduleEntity({
    required this.rescheduleProgress,
    required this.bookingId,
    required this.rescheduleInitiatorId,
    this.timestamp
  });
}

