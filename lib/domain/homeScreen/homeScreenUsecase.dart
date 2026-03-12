import 'package:reachx_embed/core/helper/requestUtils.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/domain/entities/expertsEntity.dart';
import 'package:reachx_embed/domain/homeScreen/homeScreenEntity.dart';
import 'package:reachx_embed/domain/homeScreen/homeScreenRepo.dart';

class HomeScreenUsecase {
  HomeScreenRepo homeScreenRepo = getIt();

  // Calls the repo method to fetch tutorials and returns the result as a Future.
  Future<HomeScreenEntity> fetchTutorials() async {
    return await homeScreenRepo.fetchTutorials();
  }

  // Checks if the user is online by calling the repository
  Future<bool> isLoggedIn() async {
    return await homeScreenRepo.isLoggedIn();
  }

  Future<PopularCategoryEntity> getPopularCategories() {
    return homeScreenRepo.getPopularCategories();
  }

  Future<Results> fetchTrendingProfiles() {
    return homeScreenRepo.fetchTrendingProfiles();
  }

  Future<bool> logOut() async {
    bool result = await homeScreenRepo.logOut();

    if(result) {
      homeScreenRepo.localLoginSave();
    }
    return result;
  }

  Future<ExpertEntity> fetchExpertProfile() async {
    return await homeScreenRepo.fetchExpertProfile();
  }

  void saveOnline(String storage, String status) {
    homeScreenRepo.saveOnline(storage, status);
  }

}
