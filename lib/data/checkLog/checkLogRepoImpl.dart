import 'package:reachx_embed/data/data_source/local/sharedPreferenceServices.dart';
import 'package:reachx_embed/domain/checkLog/checkLogRepo.dart';

/// Provides methods to interact with local storage for checking log status
class CheckLogRepoImpl implements CheckLogRepo {

  @override
  Future<bool> getLog(String storage) async {
    bool loggedIn = await SharedPreferenceServices().getValue(storage);
    return loggedIn;
  }
}
