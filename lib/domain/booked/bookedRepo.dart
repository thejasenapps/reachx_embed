import 'package:reachx_embed/domain/booked/bookedEntity.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/ratingEntity.dart';

abstract class BookedRepo {
  Future<BookedEntity> getBookings(String dbName);

  Future<bool> saveRating(RatingEntity ratingEntity, double newRating,  int count, String uniqueId);

  Future<ExpertEntity> getExpertDetails(String expertId);

  void updateBookingRated(String bookingId, double rating);

  Future<RescheduleEntity> getRescheduleData(String rescheduleId);

}