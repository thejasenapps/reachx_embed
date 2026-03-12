import 'package:reachx_embed/core/constants/enums.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/models/streakModel.dart';
import 'package:reachx_embed/data/passionGenerator/passionGeneratorRepoImpl.dart';
import 'package:reachx_embed/domain/entities/badgeEntity.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/domain/passionGenerator/passionGeneratorEntity.dart';
import 'package:reachx_embed/domain/passionGenerator/passionGeneratorRepo.dart';
import 'package:reachx_embed/data/hiveModels/userModel.dart' as localUser;


class PassionGeneratorUsecase {

  final PassionGeneratorRepo _passionGeneratorRepo = PassionGeneratorRepoImpl();

  Future<Results> fetchQuestions() {
    return _passionGeneratorRepo.fetchQuestions();
  }

  Future<Results> savePassion(ExpertEntity expertEntity, TopicEntity topicEntity) {
    return _passionGeneratorRepo.savePassion(expertEntity, topicEntity);
  }

  Future<Results> saveOnlyPassion(TopicEntity topicEntity) {
    return _passionGeneratorRepo.saveOnlyPassion(topicEntity);
  }

  Future<UserType> checkIfPassionate(String expertId) {
   return _passionGeneratorRepo.checkIfPassionate(expertId);
  }

  Future<Results> saveStreakData(StreakModel streakModel) {
    return _passionGeneratorRepo.saveStreakData(streakModel);
  }

  Future<int> getReachXCharge() {
    return _passionGeneratorRepo.getReachXCharge();
  }

  Future<int> getGeneratorTries(String storage) {
    return _passionGeneratorRepo.getGeneratorTries(storage);
  }

  void setGeneratorTries(String storage, int value) {
    _passionGeneratorRepo.setGeneratorTries(storage, value);
  }

  Future<Results> updatePassion(TopicEntity topicEntity) {
    return _passionGeneratorRepo.updatePassion(topicEntity);
  }


  Future<BadgeEntityList> getBadges(String title) {
    return _passionGeneratorRepo.getBadges(title);
  }

  Future<Results> saveBadge(String badgeId, TopicEntity topicEntity) {
    return _passionGeneratorRepo.saveBadge(badgeId, topicEntity);
  }

  Future<String> getCurrentBadge() {
    return _passionGeneratorRepo.getCurrentBadge();
  }

  Future<Results> saveUserLocally(localUser.UserModel userModel) {
    return _passionGeneratorRepo.saveUserLocally(userModel);
  }

  Future<Results> deleteUserLocally() {
    return _passionGeneratorRepo.deleteUserLocally();
  }

  Future<void> saveDiscoverAnswers(AnswerSheetEntity answerSheetEntity) {
    return _passionGeneratorRepo.saveDiscoverAnswers(answerSheetEntity);
  }

  Future<void> updateDiscoverAnswers(String id, Map<String,dynamic> data) {
    return _passionGeneratorRepo.updateDiscoverAnswers(id, data);
  }
}