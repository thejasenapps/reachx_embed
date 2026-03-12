import 'package:reachx_embed/domain/entities/topicEntity.dart';

abstract class TopicUploadRepo {
  Future<bool> saveTopic(TopicEntity topicEntity);

  Future<bool> updateTopic(TopicEntity topicEntity);

  Future<bool> updateEachTopicEvent(String topicId, String type, Map<String, dynamic> data);

  Future<bool> deleteAvailability(String sessionId);

  Future<int> getReachXCharge();
}