import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/navigators/navigateToBazaarOnBoardingHome.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/widgets/welcomeScreen.dart';

class BazaarWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WelcomeScreen(
      bodyImage: ImageConfig.bazaarOnBoardingWelcomeLogo,
      bodyTextTitle: TextConfig.bazaarOnboardingTitle,
      bodyTextSubtitle: TextConfig.bazaarOnboardingSubTitle,
      bottomText: TextConfig.bazaarBottomButton,
      nextIconOnPressed: NavigateToBazaarOnBoardingHome().navigate(context),
    );
  }

}
