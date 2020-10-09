import 'package:flutter/cupertino.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:gupshop/onboarding/welcomeScreen.dart';
import 'package:gupshop/passcode/unlockPasscode.dart';

class HomeAppLock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppLock(
      builder: (args) {
        return WelcomeScreen();
      },
      lockScreen: UnlockPasscode(),
      enabled: true,
    );
  }
}
