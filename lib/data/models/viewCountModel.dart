import 'package:reachx_embed/domain/entities/viewCountEntity.dart';
import 'package:uuid/uuid.dart';

class ViewCountModel extends ViewCountEntity {
  final String viewCountId;

  ViewCountModel({
    required super.expertId,
    required super.topicId,
    required super.timestamp,
    var viewCountId
  }) : viewCountId = viewCountId ?? const Uuid().v4();


  factory ViewCountModel.fromEntity(ViewCountEntity entity) {
    return ViewCountModel(
        expertId: entity.expertId,
        topicId: entity.topicId,
        timestamp: entity.timestamp
    );
  }



  Map<String, dynamic> toJson() => {
    "timestamp": timestamp,
    "expertId": expertId,
    "topicId": topicId
  };
}