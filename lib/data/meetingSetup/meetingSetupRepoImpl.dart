import 'package:reachx_embed/core/constants/rescheduleStatus.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/booked/bookedModel.dart';
import 'package:reachx_embed/data/data_source/cal_service/booking.dart';
import 'package:reachx_embed/data/data_source/cal_service/slots.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/deleteFromFireStore.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/getFromFireStore.dart';
import 'package:reachx_embed/data/data_source/remote/pushNotifications.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/saveInFirestore.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/updateInFireStore.dart';
import 'package:reachx_embed/data/meetingSetup/meetingSetupModel.dart';
import 'package:reachx_embed/data/models/userModel.dart';
import 'package:reachx_embed/domain/booked/bookedEntity.dart';
import 'package:reachx_embed/domain/entities/bookingEntity.dart';
import 'package:reachx_embed/domain/entities/slotEntity.dart';
import 'package:reachx_embed/domain/meetingSetup/meetingSetupEntity.dart';
import 'package:reachx_embed/domain/meetingSetup/meetingSetupRepo.dart';

class MeetingSetupRepoImpl implements MeetingSetupRepo {

  final GetFromFirestore _getFromFirestore = GetFromFirestore();
  final UpdateInFirestore _updateInFirestore = UpdateInFirestore();
  final SaveInFirestore _saveInFirestore = SaveInFirestore();
  final DeleteFromFirestore _deleteFromFirestore = DeleteFromFirestore();
  final FirebaseAuthentication _firebaseAuthentication = FirebaseAuthentication();

  final Slots _slots = Slots();
  final Booking _booking = Booking();
  final PushNotifications _notifications = PushNotifications();

  String content = '';
  String title = 'Reschedule Notification';
  Map<String, dynamic> data = {};

  UserModel userModel = UserModel(name: '', phoneNo: '', email: '', subscriptionStatus: 'beginner');

  /// Changes meeting status for multiple bookings
  @override
  void changeMeetingStatus(String status, List<String> bookingIds) async {
    Map<String, dynamic> data = {"meetingStatus": status};
    for (String id in bookingIds) {
      _updateInFirestore.updateBooking(id, data);
    }
  }

  /// Fetches available slots for given range and type
  @override
  Future<SlotEntity> getSlots(String start, String end, int eventTypeId) async {
    Results result = await _slots.getAvailableSlots(start, end, eventTypeId);
    if (result is SuccessState) {
      return SlotEntity(slotsByDate: result.value.slotsByDate);
    } else {
      return SlotEntity(slotsByDate: {});
    }
  }

  /// Cancels a booking (deletes for group type)
  @override
  Future<Results> cancelBooking(String bookingUniqueId, String sessionType) async {
    Results? results;
    if (sessionType != "group") {
      results = await _booking.cancelBooking(bookingUniqueId);
      if (results is SuccessState) {
        _deleteFromFirestore.deleteBooking(bookingUniqueId);
      }
    } else {
      bool response = await _deleteFromFirestore.deleteBooking(bookingUniqueId);
      results = response ? Results.success('') : Results.error('');
    }
    return results;
  }

  /// Reschedules booking to new start time
  @override
  Future<Results> rescheduleBooking(String bookingUniqueId, String start) async {
    Results results = await _booking.rescheduleBooking(bookingUniqueId, start);
    if (results is SuccessState) {
      Map<String, dynamic> data = {
        "bookingUniqueId": results.value[1],
        "bookingId": results.value[0],
        "start": start,
      };
      await _updateInFirestore.updateBooking(bookingUniqueId, data);
    }
    return results;
  }

  /// Deletes transaction by booking ID
  @override
  Future<Results> deleteTransaction(int bookingId) async {
    bool result = await _deleteFromFirestore.deleteTransaction(bookingId);
    return result ? Results.success("") : Results.error("");
  }

  /// Saves reschedule request data
  @override
  Future<bool> rescheduleConfirmation(RescheduleEntity rescheduleEntity) async {
    RescheduleModel model = RescheduleModel(
        rescheduleProgress: rescheduleEntity.rescheduleProgress,
        rescheduleInitiatorId: rescheduleEntity.rescheduleInitiatorId,
        bookingId: rescheduleEntity.bookingId,
        timestamp: rescheduleEntity.timestamp
    );

    String id = await _saveInFirestore.saveRescheduleDetails(rescheduleModel: model);
    if (id != '') {
      Map<String, dynamic> data = {
        "rescheduleStatus": rescheduleEntity.rescheduleProgress,
        "rescheduleId": id
      };
      return _updateInFirestore.updateBooking(rescheduleEntity.bookingId, data);
    }
    return false;
  }

  /// Sends push notification for rescheduling
  @override
  Future<bool> sendRescheduleNotification(String expertId, String attendeeId, String status, String bookingName) async {
    String? userId = await _firebaseAuthentication.getFirebaseUid();
    String? targetId;

    if (userId != expertId) {
      userModel = await _getFromFirestore.getUserDetails(expertId);
      targetId = expertId;
    } else if (userId != attendeeId) {
      userModel = await _getFromFirestore.getUserDetails(attendeeId);
      targetId = attendeeId;
    }

    switch (status) {
      case RescheduleStatus.started:
        content = "Reschedule Permission has been initialized for $bookingName";
        break;
      case RescheduleStatus.ongoing:
        content = "Your reschedule status for $bookingName is idle";
        break;
      case RescheduleStatus.closed:
        content = "Reschedule Invitation has been confirmed for $bookingName";
        break;
      case RescheduleStatus.rejected:
        content = "Reschedule Invitation has been rejected for $bookingName";
        break;
      case RescheduleStatus.activated:
        content = "Booking $bookingName has been rescheduled by the client";
        break;
    }

    data = {"id": targetId};
    return _notifications.sendPushNotifications([userModel.fcmToken!], title, content, data);
  }

  /// Sends notification when a booking is deleted
  @override
  Future<bool> sendDeleteNotification(String expertId, String attendeeId, String bookingName) async {
    String? userId = await _firebaseAuthentication.getFirebaseUid();
    String? targetId;
    String role = '';

    if (userId != expertId) {
      userModel = await _getFromFirestore.getUserDetails(expertId);
      targetId = expertId;
      role = 'client';
    } else if (userId != attendeeId) {
      userModel = await _getFromFirestore.getUserDetails(attendeeId);
      targetId = attendeeId;
      role = 'passionate';
    }

    content = "Your booking has been deleted by the $role";
    title = "Delete Notification";
    data = {"id": targetId};

    return _notifications.sendPushNotifications([userModel.fcmToken!], title, content, data);
  }

  @override
  Future<bool> updateStatus(String status, String bookingUniqueId, {String id = 'nil'}) async {
    if (status == RescheduleStatus.rejected && id != "nil") {
      await _deleteFromFirestore.deleteRescheduleData(id);
    }

    Map<String, dynamic> data = {
      "rescheduleStatus": status,
      "rescheduleId": id,
    };

    return _updateInFirestore.updateBooking(bookingUniqueId, data);
  }

  @override
  void saveMeetingData(MeetingSetupEntity meetingSetupEntity) async {
    MeetingSetupModel model = MeetingSetupModel(
      bookingId: meetingSetupEntity.bookingId,
      startTime: meetingSetupEntity.startTime,
      meetingUrl: meetingSetupEntity.meetingUrl,
    );

    await _saveInFirestore.saveMeetingData(meetingSetupModel: model);
  }

  @override
  Future<bool> saveMeetingUrl(List<String> bookingIds, String meetingUrl, String topicId, String sessionType) async {
    Map<String, dynamic> data = {"meetingUrl": meetingUrl};

    if(sessionType.toLowerCase() == "group") {
      _updateInFirestore.updateEvent(data, topicId);
    }

    List<Future<bool>> futures = bookingIds.map((id) => _updateInFirestore.updateBooking(id, data)).toList();
    List<bool> results = await Future.wait(futures);

    return !results.contains(false);
  }

  @override
  Future<BookingEntity> getBookingDetails(String bookingId) async {
    final bookingData = await _getFromFirestore.getMeetingDetails(bookingId);

    BookingEntity bookingEntity = BookingEntity(
      start: bookingData.start,
      lengthInMinutes: bookingData.lengthInMinutes,
      topicId: bookingData.topicId,
      eventId: bookingData.eventId,
      bookingId: bookingData.bookingId,
      bookingUniqueId: bookingData.bookingUniqueId,
      attendee: Attendee(
        name: bookingData.attendee.name,
        timeZone: bookingData.attendee.timeZone,
        email: bookingData.attendee.email,
        phoneNumber: bookingData.attendee.phoneNumber,
        language: bookingData.attendee.language,
      ),
      guests: bookingData.guests,
      location: bookingData.location,
      meetingUrl: bookingData.meetingUrl,
      eventName: bookingData.eventName,
      selectedDate: bookingData.selectedDate,
      description: bookingData.description,
      rate: bookingData.rate,
      status: bookingData.status,
      attendeeId: bookingData.attendeeId,
      expertName: bookingData.expertName,
      expertId: bookingData.expertId,
      fcmToken: bookingData.fcmToken,
      meetingStatus: bookingData.meetingStatus,
      rescheduleId: bookingData.rescheduleId,
      rescheduleStatus: bookingData.rescheduleStatus,
      rescheduleInitiator: bookingData.rescheduleInitiator,
      rescheduleDate: bookingData.rescheduleDate,
      sessionType: bookingData.sessionType,
      imageUrl: bookingData.imageUrl,
      session: bookingData.session,
      groupHours: bookingData.groupHours,
      groupSlots: bookingData.groupSlots,
      sessionId: bookingData.sessionId,
      notificationSent: bookingData.notificationSent,
      notificationSentInOneHour: bookingData.notificationSentInOneHour,
      reviewRating: bookingData.reviewRating,
      groupIds: bookingData.groupIds,
    );

    return bookingEntity;
  }

  @override
  Future<List<dynamic>> getBookingGuidelines(String type) {
    return _getFromFirestore.getBookingGuidelines(type);
  }
}