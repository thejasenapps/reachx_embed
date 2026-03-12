import 'package:flutter/cupertino.dart';
import 'package:reachx_embed/domain/entities/userEntity.dart';

abstract class SignUpRepo {
  Future<List> sendOtp(String phoneNo);

  Future<String> verifyOtp(String verificationId, String sms);

  Future<void> saveUserLocal(String storage, dynamic value);

  Future<void> saveUserRemote(String name, String phoneNo, String email, String fcmToken);

  Future<UserEntity> getLoginUser(String phoneNo, BuildContext context);

  void updateUser(String fcmToken);

  Future<bool>expertSave(String name);
}