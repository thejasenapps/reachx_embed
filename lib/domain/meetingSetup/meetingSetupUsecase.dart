import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/domain/booked/bookedEntity.dart';
import 'package:reachx_embed/domain/entities/slotEntity.dart';
import 'package:reachx_embed/domain/meetingSetup/meetingSetupRepo.dart';

class MeetingSetupUsecase {

  MeetingSetupRepo meetingSetupRepo = getIt();

  void meetingInitiated(String status, List<String> bookingIds, String meetingUrl) {
    meetingSetupRepo.changeMeetingStatus(status, bookingIds);
  }

  Future<bool> saveMeetingUrl(String meetingUrl, List<String> bookingIds, String topicId, String sessionType) {
    return meetingSetupRepo.saveMeetingUrl(bookingIds, meetingUrl, topicId, sessionType);
  }

  Future<Results> cancelBooking(List<String> bookingUniqueIds, List<int> bookingIds, String sessionType) async {
    List<Results>? results;

    List<Future<Results>> futures= [];

    for(String id in bookingUniqueIds) {
      futures.add(meetingSetupRepo.cancelBooking(id, sessionType));
    }

    results = await Future.wait(futures);

    if(results[0] is SuccessState) {
      futures.clear();
      for(int id in bookingIds) {
        futures.add(meetingSetupRepo.deleteTransaction(id));
      }
    }

    return results[0];
  }

  // Reschedules a booking by providing a new date and the booking's unique ID
  Future<Results> rescheduleBooking(String selectedDate, String bookingUniqueId) {
    return meetingSetupRepo.rescheduleBooking(bookingUniqueId, selectedDate);
  }


  Future<bool> rescheduleStatusChange(RescheduleEntity rescheduleEntity) {
    return meetingSetupRepo.rescheduleConfirmation(rescheduleEntity);
  }


  Future<bool> statusUpdate(String status, String bookingId, {String id = 'nil'}) {
    return meetingSetupRepo.updateStatus(status, bookingId, id: id);
  }


  Future<bool> sendRescheduleNotification(String expertId, String attendeeId, String status, String bookingName) {
    return meetingSetupRepo.sendRescheduleNotification(expertId, attendeeId, status, bookingName);
  }

  Future<bool> sendDeleteNotification(String expertId, String attendeeId, String bookingName) {
    return meetingSetupRepo.sendDeleteNotification(expertId, attendeeId, bookingName);
  }

  // Retrieves available slots for the next 60 days for a given event type ID
  Future<SlotEntity> getSlots(int eventTypeId) {
    DateTime start = DateTime.now();
    DateTime end = start.add(const Duration(days: 60));

    return meetingSetupRepo.getSlots(start.toUtc().toIso8601String(), end.toUtc().toIso8601String(), eventTypeId);
  }
}