import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class SignInViewModel with ChangeNotifier {
  SignInViewModel({@required this.auth});
  final FirebaseAuth auth;
  bool isLoading = false;
  bool isOtpSent = false;
  dynamic modelError;
  TextEditingController phoneNo;
  TextEditingController smsOtpController;
  String smsOTP;
  String verificationId;
  String errorMessage = '';




  Future<void> _signIn(Future<UserCredential> Function() signInMethod) async {
    try {
      isLoading = true;
      notifyListeners();
      await signInMethod();
      modelError = null;
    } catch (e) {
      modelError = e;
      rethrow;
    } finally {
      isLoading = false;
      isOtpSent = false;
      notifyListeners();
    }
  }

  Future<void> verifyPhoneNumber(BuildContext context, String number) async {

    isLoading = true;
    notifyListeners();
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      isLoading = false;
      isOtpSent = true;
      notifyListeners();
    };
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: number.trim(), // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
          smsOTPSent,
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential.toString());
          },
          verificationFailed: (FirebaseAuthException exception) {
            isLoading = false;
            notifyListeners();
            modelError = '${exception.message}';
            print('${exception.message} + something is wrong');
          });
    } catch (e) {
      handleError(e, context);
      errorMessage = e.toString();
      modelError = e.toString();
      isLoading = false;
      isOtpSent = false;
      notifyListeners();
    }
  }


  handleError(error, BuildContext context) {
    print(error);
    errorMessage = error.toString();
    modelError = errorMessage;
    notifyListeners();
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        modelError = "The verification code is invalid";
        print("The verification code is invalid");
        break;
      default:
        errorMessage = error.message;
        modelError = error.message;
        break;
    }
    notifyListeners();
  }

  Future<void> verifyOtp(String pin) async {
    isLoading = true;
    notifyListeners();
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: pin);
    await _signIn(() => auth.signInWithCredential(phoneAuthCredential));
  }
}