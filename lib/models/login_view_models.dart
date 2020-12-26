import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/service/login_auth_service.dart';
import 'package:gupshop/service/shared_preferences_service.dart';

class LoginViewModel with ChangeNotifier {
  LoginViewModel(
      {@required this.loginAuthService,
      @required this.sharedPreferencesService}) {
    AppUser appUser = sharedPreferencesService.getExistingUser();
    if (appUser != null) {
      this.user = appUser;
    }
  }

  final LoginAuthService loginAuthService;
  final SharedPreferencesService sharedPreferencesService;
  dynamic error;
  ConfirmationResult confirmationResult;
  bool isLoading = false;
  AppUser user;
  bool codeSent = false;

  /// Allows widget to send OTP code for phone auth verification.Uses [LoginAuthService] at the service layer.
  void sendCode(phoneNumber, appVerifier) {
    isLoading = true;
    notifyListeners();
    loginAuthService.sendCode(phoneNumber, appVerifier).then((result) {
      this.confirmationResult = confirmationResult;
      isLoading = false;
      codeSent = true;
      notifyListeners();
    }).catchError((onError) {
      error = onError;
      isLoading = false;
      notifyListeners();
    });
  }

  /// Abstracts [ConfirmationResult] object from Widget layer by maintaining this object as a state.
  Future<void> signInWithPhoneNumber(String smsCode) async {
    loginAuthService
        .signInWithPhoneNumber(confirmationResult, smsCode)
        .then((user) {
      this.user = user;
    })
        .catchError((onError) => error = onError);
  }
}
