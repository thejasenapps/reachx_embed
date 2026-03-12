class BookingEntity {
  String? expertName;
  String? eventName;
  String? description;
  String? selectedDate;
  String start;
  int? lengthInMinutes;
  String? topicId;
  int? eventId;
  int? bookingId;
  String? bookingUniqueId;
  Attendee attendee;
  List<String>? guests;
  String? meetingUrl;
  String? location;
  Metadata? metadata;
  BookingFieldResponses? bookingFieldResponses;
  int? rate;
  String? status;
  String? attendeeId;
  String? expertId;
  String? fcmToken;
  String? meetingStatus;
  String? rescheduleStatus;
  String? rescheduleId;
  bool? rescheduleInitiator = false;
  String? rescheduleDate;
  String? sessionType;
  String? imageUrl;
  String? session;
  int? groupHours;
  int? groupSlots;
  String? sessionId;
  bool? notificationSent;
  bool? notificationSentInOneHour;
  double? reviewRating;
  Set? groupIds;

  BookingEntity({
    required this.start,
    this.lengthInMinutes,
    this.topicId,
    this.eventId,
    this.bookingId,
    this.bookingUniqueId,
    required this.attendee,
    this.guests,
    this.location,
    this.metadata,
    this.meetingUrl,
    this.bookingFieldResponses,
    this.eventName,
    this.selectedDate,
    this.description,
    this.rate,
    this.status,
    this.attendeeId,
    this.expertName,
    this.expertId,
    this.fcmToken,
    this.meetingStatus,
    this.rescheduleId,
    this.rescheduleStatus,
    this.rescheduleInitiator,
    this.rescheduleDate,
    this.sessionType,
    this.imageUrl,
    this.session,
    this.groupHours,
    this.groupSlots,
    this.sessionId,
    this.notificationSent,
    this.reviewRating,
    this.groupIds,
    this.notificationSentInOneHour
  });
}



class Metadata {
  String key;

  Metadata({required this.key});
}


class BookingFieldResponses {
  String customField;

  BookingFieldResponses({required this.customField});
}


class Attendee {
  String name;
  String? email;
  String timeZone;
  String? phoneNumber;
  String? language;

  Attendee({
    required this.name,
    required this.timeZone,
    this.email,
    this.phoneNumber,
    this.language
  });
}