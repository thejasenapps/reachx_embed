import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/domain/booked/bookedEntity.dart';
import 'package:reachx_embed/domain/entities/slotEntity.dart';
import 'package:reachx_embed/domain/meetingSetup/meetingSetupEntity.dart';

abstract class MeetingSetupRepo {

  void changeMeetingStatus(String status, List<String> bookingIds);
  Future<bool> saveMeetingUrl(List<String> bookingIds, String meetingUrl, String topicId, String sessionType);
  void saveMeetingData(MeetingSetupEntity meetingSetupEntity);
  Future<SlotEntity> getSlots(String start, String end, int eventTypeId);
  Future<Results> cancelBooking(String bookingUniqueId, String sessionType);
  Future<Results> deleteTransaction(int bookingId);
  Future<Results> rescheduleBooking(String bookingUniqueId, String start);
  Future<bool> rescheduleConfirmation(RescheduleEntity rescheduleEntity);
  Future<bool> updateStatus(String status, String bookingUniqueId, {String id = 'nil'});
  Future<bool> sendRescheduleNotification(String expertId, String attendeeId, String status, String bookingName);
  Future<bool> sendDeleteNotification(String expertId, String attendeeId, String bookingName);
}