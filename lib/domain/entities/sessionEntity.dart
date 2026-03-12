class SessionEntity {
  String sessionId;
  int eventId;
  String session;
  String sessionType;
  int scheduleId;
  int? groupCount;
  int? groupSlotLeft;
  String? link;
  String? location;
  List<dynamic>? timeInterval;
  List<dynamic>? weekdays;
  String? dateTime;
  int? selectedHours;

  SessionEntity({
    required this.sessionId,
    required this.session,
    required this.sessionType,
    this.groupCount,
    this.link,
    this.timeInterval,
    this.location,
    this.dateTime,
    this.weekdays,
    required this.scheduleId,
    this.groupSlotLeft,
    this.selectedHours,
    required this.eventId
  });
}