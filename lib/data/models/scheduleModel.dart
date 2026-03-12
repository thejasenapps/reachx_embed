import 'package:reachx_embed/domain/entities/scheduleEntity.dart';

class TimeDaysModel extends TimeDaysEntity{
  TimeDaysModel({required super.days, required super.startTime, required super.endTime});

  factory TimeDaysModel.fromJson(Map<String, dynamic> json) => TimeDaysModel(
      days: json["days"] ?? [],
      startTime: json["startTime"] ?? '',
      endTime: json["endTime"] ?? ''
  );

  Map<String, dynamic>toJson() => {
    "days": days,
    "startTime": startTime,
    "endTime": endTime
  };
}


class ScheduleModel  extends ScheduleEntity{

  ScheduleModel({required super.name, required super.timeZone, required super.availability, required super.isDefault, super.overrides, super.id});

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
      id: json["id"],
      name: json["name"] ?? '',
      timeZone: json["timeZone"] ?? '',
      availability: (json["availability"] as List<dynamic>)
                        .map((e) => TimeDaysModel.fromJson(e)).toList(),
      isDefault: json["isDefault"] ?? false,
      overrides: json["overrides"] != null ? (json["availability"] as List<dynamic>)
          .map((e) => TimeDaysModel.fromJson(e)).toList() : null
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "timeZone": timeZone,
    "availability": availability.map((e) => (e as TimeDaysModel).toJson()).toList(),
    "isDefault": isDefault,
    "overrides": overrides?.map((e) => (e as TimeDaysModel).toJson()).toList() ?? [],
  };
}