abstract class SignState{}

class SignUpInitial extends SignState{}

class SignUpLoading extends SignState{}

class OtpSent extends SignState{

  final String verificationId;

  OtpSent(this.verificationId);
}


class OtpVerified extends SignState {
  final String uid;
  OtpVerified(this.uid);
}


class SignUpError extends SignState {

  final String message;

  SignUpError(this.message);
}