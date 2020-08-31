import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarCategory/bazaarIndividualCategoryListData.dart';

class NavigateToBazaarIndiviudalCategoryList{
  String category;


  NavigateToBazaarIndiviudalCategoryList({this.category});

  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BazaarIndividualCategoryListData(category: category,),//pass Name() here and pass Home()in name_screen
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BazaarIndividualCategoryListData(category: category,),//pass Name() here and pass Home()in name_screen
        )
    );
  }
}