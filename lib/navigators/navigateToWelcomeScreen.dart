import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/home/home.dart';
import 'package:gupshop/onboarding/welcome.dart';
import 'package:gupshop/onboarding/welcomeScreen.dart';

class NavigateToWelcomeScreen {

  navigate(BuildContext context) async {
    return () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                WelcomeScreen(),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              WelcomeScreen(),
        )
    );
  }
}