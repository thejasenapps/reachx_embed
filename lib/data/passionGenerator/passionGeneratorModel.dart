import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reachx_embed/domain/passionGenerator/passionGeneratorEntity.dart';

class PassionModel extends PassionEntity {
  PassionModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl
  });


  factory PassionModel.fromJson(Map<String, dynamic> json) => PassionModel(
      id: json["id"], 
      title: json["title"], 
      description: json["description"], 
      imageUrl: json["description"]
  );
}


class PassionsModel extends PassionsEntity {
  PassionsModel({
    required super.passionsEntity
  });
  
  factory PassionsModel.fromJson(List<QueryDocumentSnapshot> json) => PassionsModel(
      passionsEntity: List<PassionModel>.from(json.map((x) => PassionModel.fromJson(x.data() as Map<String, dynamic>)))
  );
}


class AnswerSheetModel extends AnswerSheetEntity {
  AnswerSheetModel({
    required super.id,
    required super.answers,
    required super.timestamp,
    super.passionId,
    super.userId
  });

  factory AnswerSheetModel.fromJson(Map<String, dynamic> json) {
    return AnswerSheetModel(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      passionId: json['passionId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      answers: List<String>.from(json['answers'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'passionId': passionId,
      'timestamp': timestamp.toIso8601String(),
      'answers': answers,
    };
  }

  factory AnswerSheetModel.fromEntity(AnswerSheetEntity entity) {
    return AnswerSheetModel(
      id: entity.id,
      userId: entity.userId,
      passionId: entity.passionId,
      timestamp: entity.timestamp,
      answers: entity.answers,
    );
  }

  AnswerSheetEntity toEntity() {
    return AnswerSheetEntity(
      id: id,
      userId: userId,
      passionId: passionId,
      timestamp: timestamp,
      answers: answers,
    );
  }
}