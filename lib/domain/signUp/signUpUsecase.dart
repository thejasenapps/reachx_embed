import 'package:flutter/cupertino.dart';
import 'package:reachx_embed/core/constants/localStorage.dart';
import 'package:reachx_embed/core/global_variables.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/domain/entities/userEntity.dart';
import 'package:reachx_embed/domain/signUp/signUpRepo.dart';

class SignUpUsecase {
  SignUpRepo signUpRepo = getIt();


  Future<List> sendOtp(String phoneNo) async {
    List result =  await signUpRepo.sendOtp(phoneNo);
    return result;
  }

  Future<String> verifyOtp(String verificationId, String sms, String storage) async {

    String result =  await signUpRepo.verifyOtp(verificationId, sms);
    if(result != '') {
      signUpRepo.saveUserLocal(storage, true);
      updateUser();
    }
    return result;
  }


  Future<UserEntity> getLoginSignal(String phone, BuildContext context) {
    return signUpRepo.getLoginUser(phone, context);
  }

  // Method to save the user's name and phone number remotely
  void saveText(String name, String phoneNo, String email) async {

    final saveUser = signUpRepo.saveUserLocal(nameStorage, name);
    final saveUserRemote = signUpRepo.saveUserRemote(name, phoneNo, email, fcmToken);
    final saveExpertUser = signUpRepo.expertSave(name);
    await Future.wait([saveUser, saveUserRemote, saveExpertUser]);
  }


  void updateUser() async {
    signUpRepo.updateUser(fcmToken);
  }
}
