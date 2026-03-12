import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/domain/booked/bookedEntity.dart';
import 'package:reachx_embed/domain/booked/bookedRepo.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/ratingEntity.dart';

class BookedUsecase {

  // Instance of the BookedRepo to interact with the data layer
  BookedRepo bookedRepo = getIt();

  // Fetches booking data from the repository
  Future<BookedEntity> getBookings(String dbName) {
    return bookedRepo.getBookings(dbName);
  }

  Future<bool> saveRating(RatingEntity ratingEntity, double newRating,  int count, String uniqueId) {
    return bookedRepo.saveRating(ratingEntity, newRating, count, uniqueId);
  }

  Future<ExpertEntity> getExpertDetails(String expertId) {
    return bookedRepo.getExpertDetails(expertId);
  }

  void updateBookingRated(String bookingId, double rating) {
    bookedRepo.updateBookingRated(bookingId, rating);
  }

  Future<RescheduleEntity> getRescheduleData(String rescheduleId) {
    return bookedRepo.getRescheduleData(rescheduleId);
  }

}
