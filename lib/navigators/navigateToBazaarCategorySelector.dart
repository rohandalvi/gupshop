import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarOnBoarding/categorySelector.dart';
import 'package:gupshop/modules/userDetails.dart';

class NavigateToBazaarCategorySelector{

  navigate(BuildContext context) async{

    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategorySelector(),//pass Name() here and pass Home()in name_screen
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context) async{

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategorySelector(),//pass Name() here and pass Home()in name_screen
        )
    );
  }
}