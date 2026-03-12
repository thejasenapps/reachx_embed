
import 'package:reachx_embed/domain/entities/eventEntity.dart';

class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.eventType,
    required super.mode,
    required super.eventDateTime,
    super.link,
    super.location,
    required super.thumbnail,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      eventType: json['event_type'] ?? '',
      mode: json['mode'] ?? '',
      eventDateTime: DateTime.parse(json['event_datetime']),
      link: json['link'],
      location: json['location'],
      thumbnail: json['thumbnail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'event_type': eventType,
      'mode': mode,
      'event_datetime': eventDateTime.toIso8601String(),
      'link': link,
      'location': location,
      'thumbnail': thumbnail,
    };
  }
}


class EventsModel extends EventsEntity {
  EventsModel({
    required super.events
  });

  factory EventsModel.fromJson(List<dynamic> json) => EventsModel(
      events: List<EventModel>.from(json.map((x) => EventModel.fromJson(x as Map<String, dynamic>)))
  );
}