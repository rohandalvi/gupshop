import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/navigators/navigateToWelcomeScreen.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';

class Passcode extends StatefulWidget {
  IsValidCallback isValidCallback;
  final bool opaque;
  final CircleUIConfig circleUIConfig;
  final KeyboardUIConfig keyboardUIConfig;
  final List<String> digits;
  final PasswordEnteredCallback passwordEnteredCallback;

  Passcode({this.isValidCallback,this.circleUIConfig, this.keyboardUIConfig,
    this.opaque, this.digits, this.passwordEnteredCallback});

  @override
  _PasscodeState createState() => _PasscodeState();
}

class _PasscodeState extends State<Passcode> {

  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return PasscodeScreen(
      backgroundColor:ourBlack.withOpacity(0.8),
      title: CustomText(text: 'Enter App Passcode',) ,/// size 28
      circleUIConfig: widget.circleUIConfig == null ? CircleUIConfig(borderColor: fainterGray, fillColor: fainterGray, circleSize: 30) : widget.circleUIConfig,
      keyboardUIConfig: widget.keyboardUIConfig == null ? KeyboardUIConfig(digitBorderWidth: 2, primaryColor: fainterGray) : widget.keyboardUIConfig,
      passwordEnteredCallback: _onPasscodeEntered,
      cancelButton: CustomText(text: 'Cancel',),
      deleteButton: CustomText(text: 'Delete',),
      shouldTriggerVerification: _verificationNotifier.stream,
      //backgroundColor: Colors.black.withOpacity(0.8),
      cancelCallback: _onPasscodeCancelled,
      digits: widget.digits,
      isValidCallback: (){
        if (isAuthenticated){
          NavigateToWelcomeScreen().navigateNoBrackets(context);
        }
      },
    );
  }


  /// passwordEnteredCallback
  Future<void>_onPasscodeEntered(String enteredPasscode) async{
    print("_onPasscodeEntered : $enteredPasscode");
    bool isValid = '123456' == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      setState(() {
        this.isAuthenticated = isValid;
        //widget.isValidCallback = _isValidCallBack(isValid);
      });
    }
  }


  _isValidCallBack(bool isValid){
    print("in _isValidCallBack : $isValid");
    if(isValid == true){
      NavigateToWelcomeScreen();
    }
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

