import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/bazaarHome_screen.dart';
import 'package:gupshop/modules/userDetails.dart';

class NavigateToBazaarHomeScreen{

  navigate(BuildContext context) async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    String userName = await UserDetails().getUserNameFuture();

    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BazaarHomeScreen(userName: userName,userPhoneNo: userNumber,),//pass Name() here and pass Home()in name_screen
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
          builder: (context) => BazaarHomeScreen(userName: userName,userPhoneNo: userNumber,),//pass Name() here and pass Home()in name_screen
        )
    );
  }
}