import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/sessionEntity.dart';
import 'package:reachx_embed/domain/entities/subscriptionMailEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';

abstract class ProfileExpertRepo {
  Future<bool> isOnline();
  Future<void> assignStatus(String status);
  Future<ExpertEntity> fetchExpertProfile();
  Future<TopicEntity> fetchTopicDetail(String topicId);
  Future<SessionEntity> fetchSessionDetail(String uniqueId);
  Future<void> saveOnline(String storage, String status);
  Future<bool> checkMeetingsForProfile();
  Future<bool> deleteProfile(Map<String ,List> deleteMap);
  Future<bool> deleteUserProfile();
  Future<bool> logOut();
  void localLoginSave();
  Future<String> getOfficialPhone();
  Future<Results> sendSubscriptionMail(SubscriptionMailEntity subscriptionMailEntity);

}