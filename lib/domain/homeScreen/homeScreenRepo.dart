import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/entities/institutionEntity.dart';
import 'package:reachx_embed/domain/homeScreen/homeScreenEntity.dart';

abstract class HomeScreenRepo {
  Future<HomeScreenEntity> fetchTutorials();
  Future<PopularCategoryEntity> getPopularCategories();
  Future<bool> isLoggedIn();
  Future<Results> fetchTrendingProfiles();
  Future<bool> logOut();
  void localLoginSave();
  Future<ExpertEntity> fetchExpertProfile();
  Future<void> saveOnline(String storage, String status);

  Future<InstitutionEntity> getInstitution(String institutionId);
}