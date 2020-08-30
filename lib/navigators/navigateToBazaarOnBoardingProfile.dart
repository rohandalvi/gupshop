import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarOnBoardingProfile.dart';
import 'package:gupshop/modules/userDetails.dart';


class NavigateToBazaarOnBoardingProfile{
  final List<String> listOfSubCategories;
  final String category;

  NavigateToBazaarOnBoardingProfile({this.listOfSubCategories, this.category});


  navigate(BuildContext context) async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    String userName = await UserDetails().getUserNameFuture();

    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BazaarOnBoardingProfile(
              userPhoneNo: userNumber,
              userName: userName,
              category: category,
              listOfSubCategories: listOfSubCategories,
            ),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context) async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    String userName = await UserDetails().getUserNameFuture();

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BazaarOnBoardingProfile(
            userPhoneNo: userNumber,
            userName: userName,
            category: category,
            listOfSubCategories: listOfSubCategories,
          ),
        )
    );
  }

  navigateNoBracketsPushReplacement(BuildContext context , List list) async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    String userName = await UserDetails().getUserNameFuture();

    return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BazaarOnBoardingProfile(
            userPhoneNo: userNumber,
            userName: userName,
          ),
        ),
      result: list
    );
  }
}