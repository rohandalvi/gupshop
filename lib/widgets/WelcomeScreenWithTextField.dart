import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customWelcomeBody.dart';
import 'package:gupshop/widgets/customTextFieldAndNextIcon.dart';
import 'package:gupshop/widgets/customWelcomeScreen.dart';


class WelcomeScreenWithTextField extends StatelessWidget {
  final String bodyImage;
  final String bodyTitleText;
  final String bodySubtitleText;
  final String bottomText;
  final VoidCallback nextIconOnPressed;
  String nextIcon;
  final VoidCallback onBackPressed;
  String labelText;

  ValueChanged<String> nameOnChanged;
  ValueChanged<String> onNameSubmitted;
  final VoidCallback onNextPressed;

  WelcomeScreenWithTextField({this.bodyImage, this.bodyTitleText,
    this.nextIconOnPressed, this.bottomText,this.bodySubtitleText,
    this.nameOnChanged, this.onNameSubmitted, this.onNextPressed,
    this.nextIcon,this.onBackPressed, this.labelText
  });

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomWelcomeScreen(
      bodyFlex: 3,
      bottomFlex: 2,
      body: CustomWelcomeBody(
        bottomText: bottomText,
        bodyImage: bodyImage,
        bodySubtitleText: bodySubtitleText,
        bodyTitleText: bodyTitleText,
      ),
      bottom: Expanded(
        flex: 2,
        child: CustomTextFieldAndNextIcon(
          onNextPressed: onNextPressed,
          onNameSubmitted: onNameSubmitted,
          nameOnChanged: nameOnChanged,
          nextIcon: nextIcon,
          labelText: labelText,
        ),
      ),
    );
  }
}

