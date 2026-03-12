import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/sessionEntity.dart';
import 'package:reachx_embed/domain/entities/subscriptionMailEntity.dart';
import 'package:reachx_embed/domain/entities/topicEntity.dart';
import 'package:reachx_embed/domain/profile/profileExpertRepo.dart';

class ProfileUsecase {

  ProfileExpertRepo profileExpertRepo = getIt();

  /// Fetches the expert's profile information from the repository.
  Future<ExpertEntity> fetchExpertProfile() async {
    return await profileExpertRepo.fetchExpertProfile();
  }

  /// Fetches details of a specific topic by its ID.
  Future<TopicEntity> fetchTopicDetail(String topicId) async {
    return await profileExpertRepo.fetchTopicDetail(topicId);
  }

  Future<SessionEntity> fetchSessionDetail(String uniqueId) async {
    return await profileExpertRepo.fetchSessionDetail(uniqueId);
  }

  // Checks if the user is online by calling the repository
  Future<bool> isOnline() async {
    return await profileExpertRepo.isOnline();
  }

  void assignStatus(String status) {
    profileExpertRepo.assignStatus(status);
  }


  void saveOnline(String storage, String status) {
    profileExpertRepo.saveOnline(storage, status);
  }

  /// Logs the user out and falls back to local login save if logout fails.
  Future<bool> logOut() async {
    bool result = await profileExpertRepo.logOut();

    if(result) {
      profileExpertRepo.localLoginSave();
    }
    return result;
  }

  Future<bool> checkMeetings() {
    return profileExpertRepo.checkMeetingsForProfile();
  }

  Future<bool> deleteUser({Map<String, List>? deleteMap}) {
    if(deleteMap != null) {
      return profileExpertRepo.deleteProfile(deleteMap);
    } else {
      return profileExpertRepo.deleteUserProfile();
    }
  }

  Future<String> getOfficialPhone() {
    return profileExpertRepo.getOfficialPhone();
  }

  Future<Results> sendSubscriptionMail(SubscriptionMailEntity subscriptionMailEntity) {
    return profileExpertRepo.sendSubscriptionMail(subscriptionMailEntity);
  }
}
