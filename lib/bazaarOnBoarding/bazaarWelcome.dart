import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/navigators/navigateToHome.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/widgets/welcomeScreen.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';

class BazaarWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WelcomeScreen(
      onBackPressed: () async{
        NavigateToHome(initialIndex: 1).navigateNoBrackets(context);
      },
      bodyImage: ImageConfig.bazaarOnBoardingWelcomeLogo,
      bodyTextTitle: TextConfig.bazaarOnboardingTitle,
      bodyTextSubtitle: TextConfig.bazaarOnboardingSubTitle,
      bottomText: TextConfig.bazaarBottomButton,
      nextIconOnPressed: (){
        Navigator.pushNamed(context,NavigatorConfig.bazaarOnBoardingHome);
      }
      //NavigateToBazaarOnBoardingHome().navigate(context),
    );
  }

}
