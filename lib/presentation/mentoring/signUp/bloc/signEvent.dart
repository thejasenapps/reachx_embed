import 'package:flutter/cupertino.dart';

abstract class SignEvent {}

class SubmitFormEvent extends SignEvent {
  final String name;
  final String phoneNo;
  final String email;
  final BuildContext context;

  SubmitFormEvent(this.name, this.phoneNo, this. email, this.context);
}


class VerifyOtpEvent extends SignEvent {
  final String verificationId;
  final String sms;

  VerifyOtpEvent(this.verificationId, this.sms);
}