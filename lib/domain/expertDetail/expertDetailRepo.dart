import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/sessionEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/domain/entities/viewCountEntity.dart';

abstract class ExpertDetailRepo {
  Future<ExpertEntity> fetchExpertDetails(String expertId);
  Future<TopicEntity> fetchTopicDetail(String topicId);
  Future<SessionEntity> fetchSessionDetail(String uniqueId);
  Future<Results> reportExpert(String expertId);
  Future<bool> profileViewCount(ViewCountEntity viewCountEntity);
  Future<bool> sendRequest(String expertId, String expertName);
  Future<Results> getMoments(String topicId);
}