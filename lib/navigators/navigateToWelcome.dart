import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/home/home.dart';
import 'package:gupshop/onboarding/welcome.dart';

class NavigateToWelcome {

  navigate(BuildContext context) async {
    return () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Welcome(),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Welcome(),
        )
    );
  }
}