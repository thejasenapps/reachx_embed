import 'package:reachx_embed/data/data_source/local/sharedPreferenceServices.dart';
import 'package:reachx_embed/domain/splash/splashRepo.dart';

class SplashRepoImpl implements SplashRepo {

  final SharedPreferenceServices _sharedPreferenceServices = SharedPreferenceServices();

  @override
  Future<bool> isLoggedIn() async {
    bool? isLoggedIn = await _sharedPreferenceServices.getValue("loggedIn");
    return isLoggedIn ?? false;
  }

}