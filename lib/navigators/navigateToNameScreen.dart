import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/onboarding/name_screen.dart';

class NavigateToNameScreen{
  String userPhoneNo;

  NavigateToNameScreen({this.userPhoneNo});

  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NameScreen(userPhoneNo: userPhoneNo),//pass Name() here and pass Home()in name_screen
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context){
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NameScreen(userPhoneNo: userPhoneNo),//pass Name() here and pass Home()in name_screen
        )
    );
  }
}