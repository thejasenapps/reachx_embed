import 'package:reachx_embed/domain/splash/splashUsecase.dart';

class SplashScreenViewModel {

  final SplashUsecase _splashUsecase = SplashUsecase();

  Future<bool> isLoggedIn() {
    return _splashUsecase.isLoggedIn();
  }
}