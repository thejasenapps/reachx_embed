import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reachx_embed/core/helper/dateAndTimeConvertors.dart';
import 'package:reachx_embed/core/helper/ratingLogic.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/domain/booked/bookedEntity.dart';
import 'package:reachx_embed/domain/booked/bookedUsecase.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/ratingEntity.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class BookedViewModel extends GetxController{

  final BookedUsecase _bookedUsecase = BookedUsecase();
  final FirebaseAuthentication firebaseAuthentication = FirebaseAuthentication();
  final RatingLogic _ratingLogic = RatingLogic();
  final DateAndTimeConvertors _dateAndTimeConvertors = DateAndTimeConvertors();

  RxBool isLoading = true.obs;
  RxBool isAvailable = false.obs;
  RxBool isRated = false.obs;
  RxMap<int, dynamic> latestBooking = <int, dynamic>{}.obs;


  int j = 0;
  String? userId;
  double rating = 0;
  DateTime? selectedDate;
  List<TimeOfDay> selectedTime= [];
  BookedEntity? bookedSessionsEntity;
  List<BookingEntity>? combinedEntity;
  List<BookingEntity> groupEntity = [];
  BookedEntity? bookedAppointmentsEntity;
  List<BookingEntity> finishedEntity = [];
  List<Appointment> appointments = <Appointment>[];


  TextEditingController ratingController = TextEditingController();


  // Fetches booking data from the use case
  void getSessionsBookings() async{

    groupEntity = [];

    isLoading.value = true; // Set loading to true while fetching data

    userId = await firebaseAuthentication.getFirebaseUid();

    final results = await Future.wait([
      _bookedUsecase.getBookings("attendeeId"),
      _bookedUsecase.getBookings("expertId")
    ]);


    bookedSessionsEntity = results[0];
    bookedAppointmentsEntity = results[1];

    combinedEntity = [...bookedSessionsEntity!.bookingSessions, ...bookedAppointmentsEntity!.bookingSessions];
    finishedEntity = combinedEntity!.where((b) => _dateAndTimeConvertors.compareUtcBy1Hour(b.start)).toList();

    if(combinedEntity != null) {
      combinedEntity!.removeWhere((b) => _dateAndTimeConvertors.compareUtcBy1Hour(b.start));

      List<String> toRemove = [];

      for(int i = 0; i < combinedEntity!.length; i++) {

        if(combinedEntity![i].rescheduleStatus == "initialized"  && combinedEntity![i].rescheduleId != null) {
          final result = await isRescheduleUnresponsive(combinedEntity![i].rescheduleId!);

          if(result) {
            toRemove.add(combinedEntity![i].bookingUniqueId!);
          }
        }


        if(combinedEntity![i].sessionType!.toLowerCase() == "group") {
          combinedEntity![i].groupIds = {combinedEntity![i].attendeeId};
          groupEntity.add(combinedEntity![i]);

          final cleanList = [];

          for ( j = i + 1; j < combinedEntity!.length; j++) {
            if(combinedEntity![i].topicId == combinedEntity![j].topicId  && combinedEntity![j].sessionType!.toLowerCase() == "group") {
              combinedEntity![i].groupIds!.add(combinedEntity![j].attendeeId);
              groupEntity.add(combinedEntity![j]);
              cleanList.add(combinedEntity![j]);
            }
          }

          for(var booking in cleanList) {
            combinedEntity!.remove(booking);
          }
        }
      }

      combinedEntity!.sort((a, b) => a.start.compareTo(b.start));

      combinedEntity!.removeWhere((b) => toRemove.contains(b.bookingUniqueId));
    }

    addLatestBookings(combinedEntity!);

    isLoading.value = false; // Set loading to false after data is fetched
  }


  void addLatestBookings(List<BookingEntity> bookingEntity) {
    latestBooking.clear();
    latestBooking.addAll(
        List.generate(
            bookingEntity.length.clamp(0, 2),
                (index) {
              final booking = combinedEntity![index];

              return {
                "bookingId": booking.bookingId,
                "eventName": booking.eventName,
                "description": booking.description,
                "dateTime": booking.start,
                "minutes": booking.lengthInMinutes,
                "expert": userId == booking.expertId,
              };
            }
        ).asMap()
    );
  }


  void saveRating(BuildContext context, String expertId, String bookingId) async {
    if (rating != 0) {
      // Fetch current expert details
      ExpertEntity expertEntity = await _bookedUsecase.getExpertDetails(expertId);
      // Prepare new rating entity
      RatingEntity ratingEntity = RatingEntity(
        uniqueId: expertId,
        rating: rating,
        review: ratingController.text,
      );

      // Calculate updated rating
      int newCount = expertEntity.count! + 1;
      double estimatedRating = _ratingLogic.weightedAverageRating(
        rating,
        expertEntity.rating,
        expertEntity.count!,
      );

      // Save rating and update booking if successful
      bool result = await _bookedUsecase.saveRating(
        ratingEntity,
        estimatedRating,
        newCount,
        expertEntity.uniqueId,
      );

      if (result) {
        updateBookingRated(bookingId);
      }
      isRated.value = !isRated.value;
    }
  }

  /// Marks a booking as rated by updating its rating field.
  void updateBookingRated(String bookingId) {
    _bookedUsecase.updateBookingRated(bookingId, rating);
  }


  Future<bool> isRescheduleUnresponsive(String rescheduleId) async {
    RescheduleEntity rescheduleEntity = await _bookedUsecase.getRescheduleData(rescheduleId);

    if(rescheduleEntity.timestamp != null) {

      final timestamp = rescheduleEntity.timestamp!;
      if(DateTime.now().isAfter(timestamp.add(const Duration(days: 10)))) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

}
