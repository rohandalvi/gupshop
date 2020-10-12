import 'package:flutter/cupertino.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:gupshop/onboarding/welcomeScreen.dart';
import 'package:gupshop/passcode/unlockPasscode.dart';

class HomeAppLock extends StatefulWidget {
  final bool enabled;

  HomeAppLock({this.enabled});

  @override
  _HomeAppLockState createState() => _HomeAppLockState();
}

class _HomeAppLockState extends State<HomeAppLock> {
  @override
  Widget build(BuildContext context) {
    return AppLock(
      enabled: true,
//        enabled: widget.enabled,
        lockScreen: UnlockPasscode(),
        builder: (args) {
          print("AppLock state HomeAppLock: ${AppLock.of(context)}");
          return WelcomeScreen();
        },
      );
  }
}
