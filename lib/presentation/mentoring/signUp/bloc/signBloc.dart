import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reachx_embed/domain/signUp/signUpUsecase.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/bloc/signEvent.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/bloc/signState.dart';

class SignBloc extends Bloc<SignEvent, SignState> {

  final SignUpUsecase signUpUsecase;

  String _name = '';
  String _phone = '';
  String _email = '';

  bool _isSaved = false;

  BuildContext? context;

  SignBloc(this.signUpUsecase) : super(SignUpInitial()) {
    on<SubmitFormEvent>(_onSubmitForm);
    on<VerifyOtpEvent>(_onVerifyOtp);
  }

  void _onSubmitForm(SubmitFormEvent event, Emitter<SignState> emit) async {
    emit(SignUpLoading());

    _name = event.name;
    _phone = event.phoneNo;
    _email = event.email;
    context = event.context;

    try {

      final user = await signUpUsecase.getLoginSignal(_phone, context!);

      if(user.name.isNotEmpty && user.phoneNo.isNotEmpty) {
        _isSaved = true;
      } else {
        _isSaved = false;
      }

      if (!(user.phoneNo.isEmpty && _name.isEmpty)) {
        List result = await signUpUsecase.sendOtp(event.phoneNo);
        if (result[0] == "otpsent") {
          emit(OtpSent(result[1]));
        } else if(result[0] == "InternetError") {
          emit(SignUpError("Your network is slow"));
        } else {
          emit(SignUpError("Failed to send OTP: Please try again later"));
        }
      } else {
        emit(SignUpError("SignIn details not found"));
      }
    } catch (e) {
      emit(SignUpError(e.toString()));
    }
  }

  void _onVerifyOtp(VerifyOtpEvent event, Emitter<SignState> emit) async {
    emit(SignUpLoading());
    try {
      String result = await signUpUsecase.verifyOtp(event.verificationId, event.sms, 'loggedIn');

      if (result.split(' ').first != 'Failed') {
        if(result.split(' ').first == 'Failed:' && result.split(' ')[1] == "[firebase_auth/session-expired]" || result.split(' ').first != 'Failed:') {
          emit(OtpVerified(result));
          if (_name.isNotEmpty && _email.isNotEmpty && !_isSaved) {
            signUpUsecase.saveText(_name, _phone, _email);
          }
        } else {
          emit(SignUpError("Wrong OTP. Please try again"));
        }
      } else {
        emit(SignUpError("OTP verification not successful"));
      }
    } catch (e) {
      emit(SignUpError("OTP verification not successful"));
    }
  }
}
