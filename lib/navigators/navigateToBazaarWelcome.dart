import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarWelcome.dart';

class NavigateToBazaarWelcome{

  navigate(BuildContext context){

    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BazaarWelcome(),//pass Name() here and pass Home()in name_screen
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context){

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BazaarWelcome(),//pass Name() here and pass Home()in name_screen
        )
    );
  }
}