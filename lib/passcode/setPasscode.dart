import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/passcode/appLockMethods.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/widgets/CustomPasscode.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customShowDialog.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:passcode_screen/passcode_screen.dart';

class SetPasscode extends StatefulWidget {
  @override
  _SetPasscodeState createState() => _SetPasscodeState();
}

class _SetPasscodeState extends State<SetPasscode> {

  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  String passcode;
  bool isPasscodeEnabled;
  bool isAuthenticated;

  @override
  void initState() {
    print("AppLock state SetPasscode: ${AppLock.of(context)}");
    isPasscodeEnabled = false;
    passcodeStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          CustomPasscode(
            titleText: isPasscodeEnabled == true ? TextConfig.changeAppPasscode : TextConfig.enterAppPasscode,/// size 28
//            passwordEnteredCallback: widget.passwordEnteredCallback,
            passwordEnteredCallback: _passwordEnteredCallback,
            shouldTriggerVerification: _verificationNotifier.stream,
//            shouldTriggerVerification: widget.verificationNotifier.stream,
            cancelCallback: _onPasscodeCancelled,
          ),
          disableButton(),
        ],
      ),
    );
  }



  /// passwordEnteredCallback
  Future<void> _passwordEnteredCallback(String enteredPasscode) async{
    /// show a dialog to confirm password
    /// if yes make isValid = true
    bool isValid = await confirmPasscode(enteredPasscode);

    _verificationNotifier.add(isValid);
    if (isValid) {
      /// setting the applock to enable mode
//      debugDumpApp();

      /// saving the passcode in sharedPreferences for later use
      UserDetails().setPasscode(enteredPasscode);
    }
  }


  Future<bool> confirmPasscode(String enteredPasscode) async{
    bool temp = await CustomShowDialog().confirmation(
        context,
        "Set $enteredPasscode as the new Passcode ?",
        barrierDismissible: false
    );
    return temp;
  }

  Widget disableButton(){
      return Visibility(
        visible: isPasscodeEnabled,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            child: CustomRaisedButton(
              child: CustomText(text: TextConfig.diableApplock,textColor: white,),
              borderSideColor: BorderSide(color : red),
              onPressed: () async{
//                AppLockMethods().disableAppLock(context: context);
                await UserDetails().diablePasscode();
                Navigator.pop(context);
              },
            ),
          ),
        ),
      );
  }


  passcodeStatus() async{
    bool temp =  await UserDetails().getPasscodeStatus();
    setState(() {
      isPasscodeEnabled = temp;
    });
  }



  /// cancelCallback
  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }
}

