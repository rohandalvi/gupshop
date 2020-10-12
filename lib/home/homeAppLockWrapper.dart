import 'package:flutter/cupertino.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:gupshop/onboarding/welcomeScreen.dart';
import 'package:gupshop/passcode/unlockPasscode.dart';

class HomeAppLockWrapper extends StatelessWidget {
  final bool enabled;

  HomeAppLockWrapper({this.enabled});

  @override
  Widget build(BuildContext context) {
    print("AppLock state HomeAppLockWrapper: ${AppLock.of(context)}");
    return AppLock(
      enabled: enabled,
      lockScreen: UnlockPasscode(),
      builder: (args) {
        return WelcomeScreen();
      },
    );
  }
}
