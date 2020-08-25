import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarOnBoardingProfile.dart';
import 'package:gupshop/modules/userDetails.dart';


class NavigateToBazaarOnBoardingProfile{


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
          ),
        )
    );
  }
}