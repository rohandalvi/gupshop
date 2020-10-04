import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/navigators/navigateToWelcomeScreen.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';

class CustomPasscode extends StatelessWidget {
  IsValidCallback isValidCallback;
  final bool opaque;
  final CircleUIConfig circleUIConfig;
  final KeyboardUIConfig keyboardUIConfig;
  final List<String> digits;
  final PasswordEnteredCallback passwordEnteredCallback;
  final String titleText;
  final Stream<bool> shouldTriggerVerification;
  final CancelCallback cancelCallback;

  CustomPasscode({this.isValidCallback,this.circleUIConfig, this.keyboardUIConfig,
    this.opaque, this.digits, this.passwordEnteredCallback, this.titleText,
    this.shouldTriggerVerification, this.cancelCallback});


  @override
  Widget build(BuildContext context) {
    return PasscodeScreen(
      //backgroundColor:fainterGray.withOpacity(0.8),
      title: CustomText(text: titleText,fontSize: WidgetConfig.welcomeSize, textColor: ourBlack,) ,/// size 28
      circleUIConfig: circleUIConfig == null ? CircleUIConfig(borderColor: ourBlack, fillColor: ourBlack, circleSize: WidgetConfig.circleSizeThirty) :circleUIConfig,
      keyboardUIConfig: keyboardUIConfig == null ? KeyboardUIConfig(digitBorderWidth: 2, primaryColor: ourBlack) : keyboardUIConfig,
      passwordEnteredCallback: passwordEnteredCallback,
      cancelButton: CustomText(text: TextConfig.passcodeCancel,textColor: white,fontSize: WidgetConfig.bigFontSize,),
      deleteButton: CustomText(text: TextConfig.passcodeDelete,textColor: white,fontSize: WidgetConfig.bigFontSize,),
      shouldTriggerVerification: shouldTriggerVerification,
      cancelCallback: cancelCallback,
      digits: digits,
      isValidCallback: isValidCallback
    );
  }
}

