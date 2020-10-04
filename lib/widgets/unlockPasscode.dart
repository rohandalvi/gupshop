import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/navigators/navigateToWelcomeScreen.dart';
import 'package:gupshop/widgets/CustomPasscode.dart';

class UnlockPasscode extends StatefulWidget {
  @override
  _UnlockPasscodeState createState() => _UnlockPasscodeState();
}

class _UnlockPasscodeState extends State<UnlockPasscode> {

  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return CustomPasscode(
      titleText: 'Enter App Passcode',/// size 28
      passwordEnteredCallback: _onPasscodeEntered,
      shouldTriggerVerification: _verificationNotifier.stream,
      cancelCallback: _onPasscodeCancelled,
      isValidCallback: (){
        if (isAuthenticated){
//          NavigateToWelcomeScreen().navigateNoBrackets(context);
        Navigator.pop(context);
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

