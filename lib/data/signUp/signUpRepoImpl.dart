import 'package:flutter/cupertino.dart';
import 'package:reachx_embed/core/global_passion.dart';
import 'package:reachx_embed/data/data_source/local/sharedPreferenceServices.dart';
import 'package:reachx_embed/data/data_source/remote/emailNotificationService.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/firebaseAuthentication.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/getFromFireStore.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/saveInFirestore.dart';
import 'package:reachx_embed/data/data_source/remote/firebase/updateInFireStore.dart';
import 'package:reachx_embed/data/models/expertsModel.dart';
import 'package:reachx_embed/data/models/userModel.dart';
import 'package:reachx_embed/domain/entities/userEntity.dart';
import 'package:reachx_embed/domain/signUp/signUpRepo.dart';

class SignUpRepoImpl implements SignUpRepo {


  final GetFromFirestore _getFromFirestore = GetFromFirestore();
  final UpdateInFirestore _updateInFirestore = UpdateInFirestore();
  final SaveInFirestore _saveInFirestore = SaveInFirestore();
  final FirebaseAuthentication _firebaseAuthentication = FirebaseAuthentication();

  final SharedPreferenceServices _sharedPreferenceServices = SharedPreferenceServices();
  final EmailNotificationService _emailNotificationService = EmailNotificationService();

  late UserModel userModel;


  @override
  Future<void> saveUserRemote(String name, String phoneNo, String email, String fcmToken) async {
    userModel = UserModel(
        name: name,
        phoneNo: phoneNo,
        email: email,
        fcmToken: fcmToken,
        subscriptionStatus: 'beginner',
        institutionId: globalInstitutionId.value,
    );
    final response = await _saveInFirestore.saveUser(userModel);  // Save user data remotely

    if(response) {
      sendEmail(userModel);
    }
  }


  @override
  Future<List> sendOtp(String phoneNo) async {
    List result = await _firebaseAuthentication.sendOTP(phoneNo);
    return result;  // Return the result of OTP sending
  }

  @override
  Future<String> verifyOtp(String verificationId, String sms) async {
    String result = await _firebaseAuthentication.verifyOtp(verificationId, sms);
    return result;  // Return the result of OTP verification
  }

  @override
  Future<void> saveUserLocal(String storage, dynamic value) async {
    _sharedPreferenceServices.setValue(storage, value);  // Save login status locally
  }

  @override
  Future<UserEntity> getLoginUser(String phoneNo, BuildContext context) async {
    UserEntity userEntity = await _getFromFirestore.getLoginUser(phoneNo);
    return userEntity;
  }

  @override
  void updateUser(String fcmToken) {
    _updateInFirestore.updateFCMToken(fcmToken);
  }


  @override
  Future<bool> expertSave(String name) async {
    final userId = await FirebaseAuthentication().getFirebaseUid();

    ExpertModel expertModel = ExpertModel(
      uniqueId: userId ?? '',
      name: name,
      minutes: 60,
      intro: '',
      location: '',
      experience: 0,
      languages: [],
      isExpert: false,
      status: "offline",
      achievements: [],
      imageFile: '',
      institutionId: globalInstitutionId.value,
    );

    return _saveInFirestore.saveExpertDetails(expertModel);
  }


  void sendEmail(UserModel userModel) {
    Map<String, dynamic> data = {
      "event": "sign-up",
      "name": userModel.name,
      "email": userModel.email,
      "phoneNo": userModel.phoneNo
    };

    _emailNotificationService.sendEmail(data);
  }

}
