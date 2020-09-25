import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/customWelcomeBody.dart';
import 'package:gupshop/widgets/customWelcomeBottom.dart';
import 'package:gupshop/widgets/customWelcomeScreen.dart';

class WelcomeScreen extends StatelessWidget {
  final String bodyImage;
  final String bodyTextTitle;
  final String bodyTextSubtitle;
  final String bottomText;
  final VoidCallback nextIconOnPressed;
  final VoidCallback onBackPressed;

  WelcomeScreen({this.bodyImage, this.bodyTextTitle,
    this.bodyTextSubtitle,
    this.nextIconOnPressed, this.bottomText, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return CustomWelcomeScreen(
      onBackPressed: onBackPressed,
      body: CustomWelcomeBody(
        bodyTitleText: bodyTextTitle,
        bodySubtitleText: bodyTextSubtitle,
        bodyImage: bodyImage,
        bottomText: bottomText,
      ),
      bottom: CustomWelcomeBottom(
        bottomText: bottomText,
        nextIconOnPressed: nextIconOnPressed,
      ),
    );
  }
}
