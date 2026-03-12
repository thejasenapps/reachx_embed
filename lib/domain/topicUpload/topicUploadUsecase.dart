import 'package:reachx_embed/data/topicUpload/topicUploadRepoImpl.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/domain/topicUpload/topicUploadRepo.dart';

class TopicUploadUsecase {

  TopicUploadRepo topicUploadRepo = TopicUploadRepoImpl();


  Future<bool> saveTopicDetails(TopicEntity topicEntity) {
    return topicUploadRepo.saveTopic(topicEntity);
  }


  Future<bool> updateTopicDetails(TopicEntity topicEntity) {
    return topicUploadRepo.updateTopic(topicEntity);
  }

  Future<bool> updateEachTopicEvent(String topicId, String type,  Map<String, dynamic> data) {
    return topicUploadRepo.updateEachTopicEvent(topicId, type, data);
  }

  Future<bool> deleteAvailability(String sessionId) {
    return topicUploadRepo.deleteAvailability(sessionId);
  }

  Future<int> getReachXCharge() {
    return topicUploadRepo.getReachXCharge();
  }
}