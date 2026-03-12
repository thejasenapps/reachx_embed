import 'package:reachx_embed/core/constants/enums.dart';
import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/data/hiveModels/userModel.dart';
import 'package:reachx_embed/data/models/streakModel.dart';
import 'package:reachx_embed/domain/entities/badgeEntity.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/domain/passionGenerator/passionGeneratorEntity.dart';

abstract class PassionGeneratorRepo {
  Future<Results> fetchQuestions();

  Future<Results> savePassion(ExpertEntity expertEntity, TopicEntity topicEntity);

  Future<Results> saveOnlyPassion(TopicEntity topicEntity);

  Future<UserType> checkIfPassionate(String expertId);

  Future<int> getReachXCharge();

  Future<Results> saveStreakData(StreakModel streakModel);

  Future<int> getGeneratorTries(String storage);

  void setGeneratorTries(String storage, int value);

  Future<Results> updatePassion(TopicEntity topicEntity);

  Future<BadgeEntityList> getBadges(String title);

  Future<Results> saveBadge(String badgeId, TopicEntity topicEntity);

  Future<String> getCurrentBadge();

  Future<Results> saveUserLocally(UserModel userModel);

  Future<Results> deleteUserLocally();

  Future<void> saveDiscoverAnswers(AnswerSheetEntity answerSheetEntity);

  Future<void> updateDiscoverAnswers(String id, Map<String,dynamic> data);
}