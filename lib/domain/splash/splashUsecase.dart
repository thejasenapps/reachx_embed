import 'package:reachx_embed/data/splash/splashRepoImpl.dart';
import 'package:reachx_embed/domain/splash/splashRepo.dart';

class SplashUsecase {

  final SplashRepo _splashRepo = SplashRepoImpl();

  Future<bool> isLoggedIn() async {
    return await _splashRepo.isLoggedIn();
  }
}