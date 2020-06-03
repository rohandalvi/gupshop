import 'package:flutter/material.dart';
import 'package:gupshop/screens/changeProfilePicture.dart';
import 'package:gupshop/screens/home.dart';

class CustomNavigator{
  navigateToHome(BuildContext context, String userName, String userPhoneNo){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(userName: userName,userPhoneNo: userPhoneNo,),//pass Name() here and pass Home()in name_screen
        )
    );
  }

  navigateToChangeProfilePicture(BuildContext context, String userName){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeProfilePicture(userName: userName),//pass Name() here and pass Home()in name_screen
        )
    );
  }
}