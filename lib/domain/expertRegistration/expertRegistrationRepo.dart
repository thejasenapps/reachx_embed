
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/sessionEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';

abstract class ExpertRegistrationRepo {

  Future<bool> saveImage(var selectedFile, {bool haveTopic = false});

  Future<bool> saveBasicRegistration(Map<String, dynamic> data, {bool haveTopic = false});

  Future<ExpertEntity> fetchExpertDetails();

  Future<TopicEntity> fetchTopicDetail(String topicId);

  Future<SessionEntity> fetchSessionDetail(String uniqueId);

  Future<bool> deleteTopic(String eventId, TopicEntity topicEntity, SessionEntity sessionEntity);

  Future<List<String>> locationSearch(String searchText);

  Future<bool> updateAchievements(String value, String type);

}