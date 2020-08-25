import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarOnBoarding/onBoardingCategoySelector.dart';
import 'package:gupshop/bazaarOnBoarding/onBoardingHome.dart';

class NavigateToBazaarOnBoardingHome{


  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OnBoardingHome(),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OnBoardingHome(),
        )
    );
  }
}