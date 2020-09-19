import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/widgets/customText.dart';

class WelcomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CustomText(
                text: TextConfig.bazaarOnboardingTitle,
                textAlign: TextAlign.center,
              ).welcome(),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: PaddingConfig.eight),
              child: Image.asset(
                ImageConfig.bazaarOnBoardingWelcomeLogo,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.topCenter,
              child: CustomText(
                text: TextConfig.bazaarOnboardingSubTitle,
                textAlign: TextAlign.center,
                textColor: subtitleGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
