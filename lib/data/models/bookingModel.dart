import 'package:reachx_embed/domain/entities/bookingEntity.dart';

class AttendeeModel extends Attendee {
  // Model for attendee details
  AttendeeModel({
    required super.name,
    required super.timeZone,
    super.email,
    super.language,
    super.phoneNumber
  });

  // Creates an instance from JSON
  factory AttendeeModel.fromJson(Map<String, dynamic> json) => AttendeeModel(
      name: json["name"],
      timeZone: json["timeZone"],
      email: json["email"] ?? '',
      language: json["language"] ?? '',
      phoneNumber: json["phoneNumber"] ?? ''
  );

  // Converts instance to JSON
  Map<String, dynamic> toJson() => {
    "name": name,
    "timeZone": timeZone,
    "email": email,
    "language": "en",
    "phoneNumber": phoneNumber
  };
}

class MetadataModel extends Metadata {
  // Model for metadata
  MetadataModel({required super.key});

  factory MetadataModel.fromJson(Map<String, dynamic> json) => MetadataModel(key: json["key"]);

  Map<String, dynamic> toJson() => {"key": key};
}

class BookingFieldResponsesModel extends BookingFieldResponses {
  // Model for custom booking field responses
  BookingFieldResponsesModel({required super.customField});

  factory BookingFieldResponsesModel.fromJson(Map<String, dynamic> json) =>
      BookingFieldResponsesModel(customField: json["customField"]);

  Map<String, dynamic> toJson() => {"customField": customField};
}

class BookingStorageModel extends BookingEntity {
  // Model for storing booking data
  BookingStorageModel({
    required super.start,
    required super.topicId,
    required super.attendee,
    required super.eventName,
    required super.selectedDate,
    required super.eventId,
    super.description,
    super.lengthInMinutes,
    super.guests,
    super.location,
    super.meetingUrl,
    super.metadata,
    super.bookingFieldResponses,
    super.attendeeId,
    super.rate,
    super.expertName,
    super.bookingId,
    super.bookingUniqueId,
    super.expertId,
    super.meetingStatus,
    super.rescheduleId,
    super.rescheduleStatus,
    super.sessionType,
    super.reviewRating,
    super.groupHours,
    super.groupSlots,
    super.session,
    super.sessionId,
    super.notificationSent,
    super.notificationSentInOneHour
  });

  // Creates an instance from JSON
  factory BookingStorageModel.fromJson(Map<String, dynamic> json) => BookingStorageModel(
      expertName: json['expertName'] ?? "not-given",
      eventName: json["eventName"],
      selectedDate: json["date"],
      description: json["description"],
      rate: json["rate"],
      start: json["start"],
      topicId: json["topicId"],
      eventId: json["eventId"] ?? 0,
      attendeeId: json["attendeeId"],
      attendee: AttendeeModel.fromJson(json["attendee"]),
      lengthInMinutes: json["lengthInMinutes"] ?? 60,
      meetingUrl: json["meetingUrl"] ?? '',
      meetingStatus: json["meetingStatus"] ?? '',
      location: json["location"] ?? '',
      bookingId: json["bookingId"] ?? 0,
      bookingUniqueId: json["bookingUniqueId"] ?? '',
      expertId: json["expertId"] ?? '',
      rescheduleId: json["rescheduleId"] ?? 'nil',
      rescheduleStatus: json["rescheduleStatus"] ?? 'idle',
      sessionType: json["sessionType"] ?? 'online',
      reviewRating: (json["reviewRating"] ?? 0).toDouble(),
      session: json["session"] ?? '',
      groupHours: json["groupHours"] ?? 1,
      groupSlots: json["groupSlots"] ?? 0,
      sessionId: json["sessionId"] ?? '',

  );
}



class OnlineOneToOneStorageModel extends BookingEntity {
  // Model for storing booking data
  OnlineOneToOneStorageModel({
    required super.start,
    required super.topicId,
    required super.eventId,
    required super.attendee,
    required super.eventName,
    required super.selectedDate,
    super.description,
    super.lengthInMinutes,
    super.guests,
    super.meetingUrl,
    super.metadata,
    super.bookingFieldResponses,
    super.attendeeId,
    super.rate,
    super.expertName,
    super.bookingId,
    super.bookingUniqueId,
    super.expertId,
    super.meetingStatus,
    super.rescheduleId,
    super.rescheduleStatus,
    super.sessionType,
    super.reviewRating,
    super.session,
    super.sessionId,
    super.notificationSent
  });


  // Converts instance to JSON
  Map<String, dynamic> toJson() => {
    "expertName": expertName,
    "eventName": eventName,
    "description": description,
    "selectedDate": selectedDate,
    "rate": rate,
    "start": start,
    "topicId": topicId,
    "eventId": eventId,
    "bookingId": bookingId ?? 0,
    "bookingUniqueId": bookingUniqueId ?? '',
    "attendeeId": attendeeId,
    "attendee": AttendeeModel(
      name: attendee.name,
      timeZone: attendee.timeZone,
      email: attendee.email,
      language: attendee.language,
      phoneNumber: attendee.phoneNumber,
    ).toJson(),
    "lengthInMinutes": lengthInMinutes ?? 60,
    "meetingUrl": meetingUrl ?? '',
    "meetingStatus": meetingStatus ?? '',
    "expertId": expertId ?? '',
    "rescheduleStatus": rescheduleStatus ?? 'idle',
    "rescheduleId": rescheduleId ?? 'nil',
    "sessionType": sessionType,
    "reviewRating": reviewRating ?? 0,
    "session": session ?? '',
    "sessionId": sessionId ?? '',
    "notificationSent": notificationSent ?? false,
    "notificationSentInOneHour": notificationSentInOneHour ?? false
  };
}

class OnlineGroupStorageModel extends BookingEntity {
  // Model for storing booking data
  OnlineGroupStorageModel({
    required super.start,
    required super.eventName,
    required super.selectedDate,
    required super.attendee,
    super.attendeeId,
    super.description,
    super.lengthInMinutes,
    super.meetingUrl,
    super.metadata,
    super.bookingFieldResponses,
    super.rate,
    super.expertName,
    super.bookingId,
    super.bookingUniqueId,
    super.expertId,
    super.meetingStatus,
    super.rescheduleId,
    super.rescheduleStatus,
    super.sessionType,
    super.reviewRating,
    super.groupSlots,
    super.session,
    super.sessionId,
    super.notificationSent,
    required super.topicId,
  });


  // Converts instance to JSON
  Map<String, dynamic> toJson() => {
    "expertName": expertName,
    "topicId": topicId,
    "eventName": eventName,
    "description": description,
    "rate": rate,
    "start": start,
    "lengthInMinutes": lengthInMinutes ?? 60,
    "meetingUrl": meetingUrl ?? '',
    "meetingStatus": meetingStatus ?? '',
    "expertId": expertId ?? '',
    "bookingUniqueId": bookingUniqueId ?? '',
    "rescheduleStatus": rescheduleStatus ?? 'idle',
    "rescheduleId": rescheduleId ?? 'nil',
    "sessionType": sessionType,
    "reviewRating": reviewRating?? 0,
    "session": session ?? '',
    "groupSlots": groupSlots ?? 0,
    "attendeeId": attendeeId,
    "attendee": AttendeeModel(
      name: attendee.name,
      timeZone: attendee.timeZone,
      email: attendee.email,
      language: attendee.language,
      phoneNumber: attendee.phoneNumber,
    ).toJson(),
    "sessionId": sessionId ?? '',
    "notificationSent": notificationSent ?? false,
    "notificationSentInOneHour": notificationSentInOneHour ?? false
  };
}


class OfflineOneToOneStorageModel extends BookingEntity {
  // Model for storing booking data
  OfflineOneToOneStorageModel({
    required super.start,
    required super.topicId,
    required super.eventId,
    required super.attendee,
    required super.eventName,
    required super.selectedDate,
    super.description,
    super.lengthInMinutes,
    super.guests,
    super.location,
    super.metadata,
    super.bookingFieldResponses,
    super.attendeeId,
    super.rate,
    super.expertName,
    super.bookingId,
    super.bookingUniqueId,
    super.expertId,
    super.meetingStatus,
    super.rescheduleId,
    super.rescheduleStatus,
    super.sessionType,
    super.reviewRating,
    super.session,
    super.sessionId,
    super.notificationSent
  });


  // Converts instance to JSON
  Map<String, dynamic> toJson() => {
    "expertName": expertName,
    "eventName": eventName,
    "description": description,
    "date": selectedDate,
    "rate": rate,
    "start": start,
    "topicId": topicId,
    "eventId": eventId,
    "bookingId": bookingId ?? 0,
    "bookingUniqueId": bookingUniqueId ?? '',
    "attendeeId": attendeeId,
    "attendee": AttendeeModel(
      name: attendee.name,
      timeZone: attendee.timeZone,
      email: attendee.email,
      language: attendee.language,
      phoneNumber: attendee.phoneNumber,
    ).toJson(),
    "lengthInMinutes": lengthInMinutes ?? 60,
    "location": location ?? '',
    "meetingStatus": meetingStatus ?? '',
    "expertId": expertId ?? '',
    "rescheduleStatus": rescheduleStatus ?? 'idle',
    "rescheduleId": rescheduleId ?? 'nil',
    "sessionType": sessionType,
    "reviewRating": reviewRating ?? 0,
    "session": session ?? '',
    "sessionId": sessionId ?? '',
    "notificationSent": notificationSent ?? false,
    "notificationSentInOneHour": notificationSentInOneHour ?? false
  };
}



class OfflineGroupStorageModel extends BookingEntity {
  // Model for storing booking data
  OfflineGroupStorageModel({
    required super.start,
    required super.eventName,
    required super.selectedDate,
    super.description,
    super.lengthInMinutes,
    super.metadata,
    super.bookingFieldResponses,
    super.attendeeId,
    super.rate,
    super.expertName,
    super.bookingId,
    super.bookingUniqueId,
    super.expertId,
    super.meetingStatus,
    super.rescheduleId,
    super.rescheduleStatus,
    super.sessionType,
    super.reviewRating,
    super.groupSlots,
    super.session,
    super.location,
    required super.attendee,
    super.sessionId,
    super.notificationSent,
    required super.topicId,
  });


  // Converts instance to JSON
  Map<String, dynamic> toJson() => {
    "expertName": expertName,
    "topicId": topicId,
    "eventName": eventName,
    "description": description,
    "date": selectedDate,
    "rate": rate,
    "start": start,
    "bookingId": bookingId ?? 0,
    "bookingUniqueId": bookingUniqueId ?? '',
    "lengthInMinutes": lengthInMinutes ?? 60,
    "meetingStatus": meetingStatus ?? '',
    "expertId": expertId ?? '',
    "rescheduleStatus": rescheduleStatus ?? 'idle',
    "rescheduleId": rescheduleId ?? 'nil',
    "sessionType": sessionType,
    "location": location ?? '',
    "reviewRating": reviewRating  ?? 0,
    "session": session ?? '',
    "groupSlots": groupSlots ?? 0,
    "attendeeId": attendeeId,
    "attendee": AttendeeModel(
      name: attendee.name,
      timeZone: attendee.timeZone,
      email: attendee.email,
      language: attendee.language,
      phoneNumber: attendee.phoneNumber,
    ).toJson(),
    "sessionId": sessionId ?? '',
    "notificationSent": notificationSent ?? false,
    "notificationSentInOneHour": notificationSentInOneHour ?? false
  };
}






class BookingScheduleModel extends BookingEntity {
  // Model for scheduling bookings
  BookingScheduleModel({
    required super.start,
    required super.eventId,
    required super.attendee,
    super.lengthInMinutes,
    super.guests,
    super.location,
    super.meetingUrl,
    super.metadata,
    super.bookingFieldResponses
  });

  // Creates an instance from JSON
  factory BookingScheduleModel.fromJson(Map<String, dynamic> json) => BookingScheduleModel(
    start: json["start"],
    eventId: json["eventTypeId"],
    attendee: AttendeeModel.fromJson(json["attendee"]),
    lengthInMinutes: json["lengthInMinutes"] ?? 60,
    meetingUrl: json["meetingUrl"] ?? '',
    guests: json["guests"] ?? [],
    metadata: json["metadata"] != null ? MetadataModel.fromJson(json["metadata"]) : null,
    bookingFieldResponses: json["bookingFieldResponses"] != null
        ? BookingFieldResponsesModel.fromJson(json["bookingFieldResponses"])
        : null,
  );

  // Converts instance to JSON
  Map<String, dynamic> toJson() => {
    "start": start,
    "eventTypeId": eventId,
    "attendee": (attendee as AttendeeModel).toJson(),
    "lengthInMinutes": lengthInMinutes ?? 60,
    if (meetingUrl != '') "meetingUrl": meetingUrl,
    if (metadata != null) "metadata": (metadata as MetadataModel).toJson(),
    if (bookingFieldResponses != null)
      "bookingFieldResponses": (bookingFieldResponses as BookingFieldResponsesModel).toJson(),
  };
}
