import 'package:reachx_embed/domain/entities/sessionEntity.dart';

class SessionModel extends SessionEntity {
  SessionModel({
    required super.session,
    required super.sessionType,
    required super.sessionId,
    required super.eventId,
    super.groupCount,
    super.dateTime,
    super.timeInterval,
    super.link,
    super.weekdays,
    super.location,
    required super.scheduleId,
    super.groupSlotLeft,
    super.selectedHours
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) => SessionModel(
      sessionId: json["sessionId"],
      session: json["session"],
      sessionType: json["sessionType"],
      scheduleId: json["scheduleId"] ?? 0,
      groupCount: json["groupCount"] ?? 0,
      groupSlotLeft: json["groupSlotLeft"] ?? 0,
      dateTime: json["dateTime"] ?? '',
      timeInterval: json["timeInterval"] ?? [],
      link: json["link"] ?? '',
      location: json["location"] ?? '',
      weekdays: json["weekdays"] ?? [],
      selectedHours: json["selectedHours"] ?? 1,
      eventId: json["eventId"] ?? 0
  );


  Map<String, dynamic> toJson() => {
    "sessionId": sessionId,
    "session": session,
    "sessionType": sessionType,
    "scheduleId": scheduleId,
    "groupCount": groupCount ?? 0,
    "groupSlotLeft": groupSlotLeft ?? 0,
    "dateTime" : dateTime ?? '',
    "timeInterval": timeInterval ?? [],
    "link": link ?? '',
    "location": location ?? '',
    "weekdays": weekdays ?? [],
    "selectedHours": selectedHours ?? 1,
    "eventId": eventId ?? 0
  };
}