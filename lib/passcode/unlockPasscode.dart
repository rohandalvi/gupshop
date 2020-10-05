import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/passcode/appLockMethods.dart';
import 'package:gupshop/responsive/textConfig.dart';
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
    print("in unlockPasscode");
    return CustomPasscode(
      titleText: TextConfig.enterAppPasscode,/// size 28
      passwordEnteredCallback: _onPasscodeEntered,
      shouldTriggerVerification: _verificationNotifier.stream,
      cancelCallback: _onPasscodeCancelled,
      isValidCallback: (){
        if (isAuthenticated){
          AppLockMethods().didUnlock(context: context, unlock: true);
//          NavigateToWelcomeScreen().navigateNoBrackets(context);
        //Navigator.pop(context);
        }
      },
    );
  }


  /// passwordEnteredCallback
  Future<void>_onPasscodeEntered(String enteredPasscode) async{
    String code = await UserDetails().getPasscode();
    /// the user would come to this screen only if he is already enabled
    /// applock. So there is no need to check if 'code' has value or is empty

    if(code.isNotEmpty){
      bool isValid = code == enteredPasscode;
      _verificationNotifier.add(isValid);
      if (isValid) {
        setState(() {
          this.isAuthenticated = isValid;
          //widget.isValidCallback = _isValidCallBack(isValid);
        });
      }
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

