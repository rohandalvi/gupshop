import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
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
  final Widget cancelButton;
  final Widget deleteButton;

  CustomPasscode({this.isValidCallback,this.circleUIConfig, this.keyboardUIConfig,
    this.opaque, this.digits, this.passwordEnteredCallback, this.titleText,
    this.shouldTriggerVerification, this.cancelCallback, this.cancelButton, this.deleteButton});


  @override
  Widget build(BuildContext context) {
    return PasscodeScreen(
      //backgroundColor:fainterGray.withOpacity(0.8),
      title: CustomText(text: titleText,fontSize: WidgetConfig.welcomeSize, textColor: white,) ,/// size 28
      circleUIConfig: circleUIConfig == null ? CircleUIConfig(borderColor: white, fillColor: white, circleSize: WidgetConfig.circleSizeThirty) :circleUIConfig,
      keyboardUIConfig: keyboardUIConfig == null ? KeyboardUIConfig(digitBorderWidth: 2, primaryColor: white) : keyboardUIConfig,
      passwordEnteredCallback: passwordEnteredCallback,
      cancelButton: cancelButton == null ?CustomText(text: TextConfig.passcodeCancel,textColor: white,fontSize: WidgetConfig.bigFontSize,) : cancelButton,
      deleteButton: deleteButton == null ?CustomText(text: TextConfig.passcodeDelete,textColor: white,fontSize: WidgetConfig.bigFontSize,) : deleteButton,
      shouldTriggerVerification: shouldTriggerVerification,
      cancelCallback: cancelCallback,
      digits: digits,
      isValidCallback: isValidCallback
    );
  }
}

