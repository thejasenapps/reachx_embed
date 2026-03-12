
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/sessionEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/domain/expertRegistration/expertRegistrationRepo.dart';

/// Use case class for managing expert registration logic
class ExpertRegistrationUsecase {
  final ExpertRegistrationRepo _expertRegistrationRepo = getIt();


  Future<List<String>> locationResults(String searchText) {
    return _expertRegistrationRepo.locationSearch(searchText);
  }

  Future<ExpertEntity> fetchExpertDetails() {
    return _expertRegistrationRepo.fetchExpertDetails();
  }

  Future<bool> saveImage(var selectedFile, {bool haveTopic = false}) {
    return _expertRegistrationRepo.saveImage(selectedFile, haveTopic: haveTopic);
  }

  Future<bool> saveBasicRegistration(Map<String, dynamic> data, {bool haveTopic = false}) {
    return _expertRegistrationRepo.saveBasicRegistration(data, haveTopic: haveTopic);
  }


  Future<TopicEntity> fetchTopicDetail(String topicId) async {
    return _expertRegistrationRepo.fetchTopicDetail(topicId);
  }

  Future<SessionEntity> fetchSessionDetail(String uniqueId) async {
    return _expertRegistrationRepo.fetchSessionDetail(uniqueId);
  }

  Future<bool> deleteTopic(String eventId, TopicEntity topicEntity, SessionEntity sessionEntity) {
    return _expertRegistrationRepo.deleteTopic(eventId, topicEntity, sessionEntity);
  }

  Future<bool> updateAchievements(String value, String type) {
    return _expertRegistrationRepo.updateAchievements(value, type);
  }
}
