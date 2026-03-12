import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/domain/checkLog/checkLogRepo.dart';

class CheckLogUsecase {

  CheckLogRepo checkLogRepo = getIt();

  Future<bool> getLog(String storage) {
    return checkLogRepo.getLog(storage);
  }
}