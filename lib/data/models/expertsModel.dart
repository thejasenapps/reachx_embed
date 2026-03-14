
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';


class ExpertModel extends ExpertEntity {

  ExpertModel({
    required super.uniqueId,
    required super.name,
    required super.minutes,
    super.topics,
    required super.intro,
    required super.location,
    required super.experience,
    super.rating,
    super.review,
    super.count,
    super.status,
    required super.languages,
    required super.imageFile,
    super.imageId,
    super.isExpert,
    required super.achievements,
    super.badgeId,
    super.timestamp,
  });  // Initialize the base class with name and phoneNo

  factory ExpertModel.fromJson(Map<String, dynamic> json) => ExpertModel(
      uniqueId: json["uniqueId"] ?? '',
      name: json["name"] ?? '',
      minutes: json["minutes"] ?? 60,
      experience: json["experience"] ?? 0,
      location: json["location"] ?? "unknown",
      topics: json["topics"] ?? [],
      intro: json["intro"] ?? '',
      rating: json["rating"] ?? 0,
      review: json['review'] ?? '',
      count: json["count"] ?? 0,
      status: json["status"] ?? "online",
      languages: json["languages"] != null ? List<String>.from(json["languages"]) : [],
      imageFile: json["imageFile"] ?? '',
      imageId: json["imageId"] ?? '',
      achievements: json["achievements"] != null ? List<String>.from(json["achievements"]) : [],
      isExpert: json["isExpert"] ?? true,
      badgeId: json["badgeId"] ?? '',
      timestamp: json["timestamp"] != null ? (json["timestamp"] as Timestamp).toDate() : null,
  );

  Map<String, dynamic> toJson() => {
    'uniqueId': uniqueId,
    'name': name,
    'minutes': minutes,
    'experience': experience,
    'location': location,
    'topics': topics,
    'intro': intro,
    'status': status ?? "offline",
    'languages': languages,
    'imageFile': imageFile,
    'imageId': imageId ?? '',
    'isExpert': isExpert ?? false,
    'achievements': achievements ,
    'badgeId': badgeId ?? '',
    'timestamp': timestamp,
  };
}

class ExpertsModel  extends ExpertsEntity{

  ExpertsModel({required super.experts});

  factory ExpertsModel.fromRawJson(dynamic str) => ExpertsModel.fromJson(str);

  factory ExpertsModel.fromJson(dynamic json) => ExpertsModel(
      experts: List<ExpertModel>.from(json.map((x) => ExpertModel.fromJson(x)))
  );
}


