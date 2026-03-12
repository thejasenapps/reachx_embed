import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reachx_embed/domain/entities/streakEntity.dart';

class StreakModel extends StreakEntity{
  StreakModel({
    required super.lastCount,
    required super.lastUpdatedDate,
    required super.passionId,
    required super.userId,
    required super.answered,
    required super.completed
  });


  factory StreakModel.fromJson(Map<String, dynamic> json) => StreakModel(
      lastCount: json["lastCount"] ?? 0,
      lastUpdatedDate: (json["lastUpdateDate"] as Timestamp).toDate(),
      passionId: json["passionId"],
      userId: json["userId"],
      answered: json["answered"] ?? false,
      completed: json["completed"] ?? false
  );


  Map<String, dynamic> toJson() => {
    "lastCount": lastCount,
    "lastUpdateDate": lastUpdatedDate,
    "passionId": passionId,
    "userId": userId,
    "answered": answered,
    "completed": completed
  };
}