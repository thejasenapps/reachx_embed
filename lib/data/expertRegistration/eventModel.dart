import 'package:reachx_embed/domain/expertRegistration/eventEntity.dart';

class EventModel extends EventEntity {
  EventModel({
    required super.title,
    required super.slug,
    required super.lengthInMinutes,
    required super.lengthInMinutesOptions,
    required super.description,
    required super.scheduleId
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
      title: json["title"] ?? '',
      slug: json["slug"] ?? '',
      description: json["description"] ?? '',
      lengthInMinutes: json["lengthInMinutes"] ?? 0,
      lengthInMinutesOptions: json["lengthInMinutesOptions"] ?? [],
      scheduleId: json["scheduleId"] ?? []
  );


  Map<String, dynamic> toJson() => {
    "title": title,
    "slug": slug,
    "description": description,
    "lengthInMinutes": lengthInMinutes,
    "lengthInMinutesOptions": lengthInMinutesOptions,
    "scheduleId": scheduleId
  };
}