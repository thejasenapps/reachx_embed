import 'package:reachx_embed/domain/entities/subscriptionMailEntity.dart';

class SubscriptionMailModel extends SubscriptionMailEntity {
  SubscriptionMailModel({
    required super.id,
    required super.event,
    required super.level,
    required super.section,
    required super.currentLevel
  });


  Map<String, dynamic> toJson() => {
    "id": id,
    "event": event,
    "section": section,
    "level": level,
    "currentLevel": currentLevel
  };
}
