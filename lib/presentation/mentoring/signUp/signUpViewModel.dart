import 'package:flutter/material.dart';
import 'package:get/get.dart';


String name = '';
String phoneNo = '';
String email = '';

final nameController = TextEditingController();
final phoneController = TextEditingController();
final emailController = TextEditingController();

class SignUpViewModel extends GetxController {

  // Observable boolean to track login response state
  RxBool loginResponse = false.obs;

  bool isLoading = false;

  TextEditingController pinputController = TextEditingController();

  // Toggles the login response state
  void broadCastLogin() {
    loginResponse.value = !loginResponse.value;
  }
}




