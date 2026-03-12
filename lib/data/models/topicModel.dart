import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';

class TopicModel extends TopicEntity{
  TopicModel({
    required super.expertId,
    required super.name,
    required super.description,
    required super.sessionId,
    required super.session,
    required super.sessionType,
    required super.topicRate,
    required super.expertName,
    super.location,
    required super.topicId,
    super.expertise,
    super.rating,
    super.count,
    super.status,
    super.skillType,
    super.imageUrl,
    super.audio,
    super.audioId,
    super.languages,
    super.currencySymbol,
    super.momentsIds,
    super.keywordId,
    required super.availability,
    super.meetingUrl,
    super.badgeId,
    super.timestamp
  });


  factory TopicModel.fromJson(Map<String, dynamic> json) => TopicModel(
    expertId: json["expertId"],
    expertName: json["expertName"],
    name: json["name"],
    keywordId: json["keywordId"] ?? '',
    topicId: json["topicId"] ?? '',
    description: json["description"],
    sessionId: json["sessionId"] ?? '',
    session: json["session"] ?? '',
    sessionType: json["sessionType"] ?? '',
    topicRate: json["topicRate"] ?? 0,
    location: json["location"] ?? '',
    expertise: (json["expertise"] as List<dynamic>?)
        ?.map((expertise) => expertise as String).toList() ?? [],
    rating: json["rating"] ?? 0,
    count: json["count"] ?? 0,
    status: json["status"] ?? "offline",
    skillType: json["skillType"] ?? "professional",
    imageUrl: json["imageUrl"] ?? "",
    audio: json["audio"],
    audioId:json["audioId"],
    languages:  (json["languages"] as List<dynamic>?)
        ?.map((language) => language as String).toList() ?? [],
    currencySymbol: json["currencySymbol"] ?? '₹',
    momentsIds: (json["momentsIds"] as List<dynamic>?)
        ?.map((momentId) => momentId as String).toList() ?? [],
    availability: json["availability"] ?? false,
    meetingUrl: json["meetingUrl"] ?? '',
    badgeId: json["badgeId"] ?? '',
    timestamp: json["timestamp"] != null ? (json["timestamp"] as Timestamp).toDate() : null
  );

  Map<String, dynamic> toJson() => {
    "expertId": expertId,
    "expertName": expertName,
    "name": name,
    "keywordId": keywordId,
    "topicId": topicId,
    "description": description,
    "sessionId":sessionId,
    "sessionType": sessionType,
    "session": session,
    "location": location,
    "topicRate": topicRate,
    "expertise": expertise,
    "status": status ?? "offline",
    "skillType": skillType,
    "imageUrl": imageUrl ?? "",
    "audio": audio ?? "",
    "audioId": audioId ?? "",
    "languages": languages ?? [],
    "currencySymbol": currencySymbol ?? "₹",
    "momentsIds": momentsIds,
    "availability": availability,
    "meetingUrl": meetingUrl ?? '',
    "badgeId": badgeId ?? '',
    "timestamp":timestamp
  };
}


class TopicsModel extends TopicsEntity {
  TopicsModel ({required super.topics});

  factory TopicsModel.fromRawJson(dynamic str) => TopicsModel.fromJson(str);

  factory TopicsModel.fromJson(List<QueryDocumentSnapshot> json) => TopicsModel(
      topics: List<TopicModel>.from(json.map((x) => TopicModel.fromJson(x.data() as Map<String, dynamic>)))
  );
}