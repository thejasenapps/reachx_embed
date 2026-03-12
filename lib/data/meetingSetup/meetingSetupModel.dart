import 'package:reachx_embed/domain/meetingSetup/meetingSetupEntity.dart';

class MeetingSetupModel extends MeetingSetupEntity{

  MeetingSetupModel({
    required super.bookingId,
    required super.startTime,
    required super.meetingUrl
  });

  factory MeetingSetupModel.fromJson(Map<String, dynamic> json) => MeetingSetupModel(
      bookingId: json["bookingId"] ?? '',
      startTime: json["startTime"] ?? '',
      meetingUrl: json["meetingUrl"] ?? ''
  );


  Map<String,dynamic> toJson() => {
    "bookingId": bookingId,
    "startTime": startTime,
    "meetingUrl": meetingUrl
  };
}