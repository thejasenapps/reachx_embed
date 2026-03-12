import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:reachx_embed/core/injections.dart';
import 'package:reachx_embed/presentation/mentoring/signUp/signUpViewModel.dart';

/// Service class for Firebase authentication using phone number OTP
class FirebaseAuthentication {
  SignUpViewModel signUpViewModel = getIt();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  /// Sends OTP to the provided phone number
  /// Returns a list with the result status and additional information (verificationId or error message)
  Future<List> sendOTP(String phoneNumber) async {

    try {
      final completer = Completer<List<dynamic>>();

      // Verifies the phone number and handles different verification states
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            try {
              // signUpViewModel.pinputController.setText(credential.smsCode!);
              // Automatically signs in if verification is successful
              await _auth.signInWithCredential(credential);
              completer.complete(["verified", null]);
            } catch (e) {
              print('Automatic sign-in failed: $e');
              completer.complete(["failed", e]);
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            print('verification failed ${e.message}');
            completer.complete(["failed", e]);
          },
          codeSent: (String verificationId, int? resendToken) {
            // OTP successfully sent to the phone number
            completer.complete(["otpsent", verificationId]);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // Timeout for automatic code retrieval
            print('Auto retrieval time out');
            // completer.complete(["timeout", verificationId]);
          }
      );
      return await completer.future;
    } on SocketException catch (_) {
      return ["Internet Error", null];
    } catch (e) {
      print('Unexpected error: $e');
      return ["not-set", e];
    }
  }

  /// Verifies the OTP entered by the user
  /// Returns true if the sign-in is successful, otherwise false
  Future<String> verifyOtp(String verificationId, String sms) async {
    try {
      // Creates a PhoneAuthCredential with the provided OTP details
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: sms
      );

      // Signs in with the credential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      String uid = userCredential.user?.uid ?? '';
      return uid;

    } catch (e) {
      print("Failed $e");
      return "Failed: $e";
    }
  }



  // Retrieves the Firebase UID of the currently authenticated user
  Future<String?> getFirebaseUid() async {
    try {
      // Gets the current user from Firebase Auth
      User? user = _auth.currentUser;

      // If user is logged in, return their UID, otherwise return null
      if( user != null) {
        return user.uid;
      } else {
        return null;
      }
    } catch(error) {
      // Logs any errors that occur during the process
      print('Error getting UID: $error');
      return null;
    }
  }

  Future<bool> signOut() async {
    try {
      // Gets the current user from Firebase Auth
      User? user = _auth.currentUser;

      // If user is logged in, return their UID, otherwise return null
      if( user != null) {
        await _auth.signOut();
        return true;
      } else {
        return false;
      }
    } catch(error) {
      // Logs any errors that occur during the process
      print('Error getting UID: $error');
      return false;
    }
  }


  Future<bool> deleteFirebaseUser() async {
    try{
      User? user = _auth.currentUser;

      if(user != null) {
        await user.delete();
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if(e.code == 'requires-recent-login') {
        print('user needs to re-authenticate before deleting the account');
      } else {
        print('Auth deletion error: $e.code');
      }
      return false;
    } catch(e) {
      print('Unexpected error: $e');
      return false;
    }
  }

}
