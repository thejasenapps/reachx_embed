import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/sessionEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/domain/entities/viewCountEntity.dart';
import 'package:reachx_embed/domain/expertDetail/expertDetailRepo.dart';

class ExpertDetailUsecase {

  ExpertDetailRepo expertDetailRepo = getIt();

  Future<ExpertEntity> fetchExpertDetails(String expertId) async {
    return expertDetailRepo.fetchExpertDetails(expertId);
  }

  Future<TopicEntity> fetchTopic(String topicId) async {
    return expertDetailRepo.fetchTopicDetail(topicId);
  }

  Future<SessionEntity> fetchSessionDetail(String sessionId) async {
    return expertDetailRepo.fetchSessionDetail(sessionId);
  }


  Future<Results> reportExpert(String expertId) async {
    return expertDetailRepo.reportExpert(expertId);
  }

  Future<bool> saveProfileViewCount(ViewCountEntity viewCountEntity) {
    return expertDetailRepo.profileViewCount(viewCountEntity);
  }

  Future<bool> sendRequest(String expertId, String expertName) {
    return expertDetailRepo.sendRequest(expertId, expertName);
  }

  Future<Results> getMoments(String topicId) {
    return expertDetailRepo.getMoments(topicId);
  }

}