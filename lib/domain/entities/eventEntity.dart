
import 'package:reachx_embed/data/models/eventModel.dart';

class EventEntity {
  final String id;
  final String title;
  final String description;
  final String eventType; // webinar, workshop, etc.
  final String mode; // online/offline
  final DateTime eventDateTime;
  final String? link;
  final String? location;
  final String thumbnail;

  const EventEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.eventType,
    required this.mode,
    required this.eventDateTime,
    this.link,
    this.location,
    required this.thumbnail,
  });
}



class EventsEntity {
  List<EventModel> events;

  EventsEntity({
    required this.events
  });
}