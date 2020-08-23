import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gupshop/onboarding/login_screen.dart';
import 'package:gupshop/onboarding/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home.dart';


/*
Steps:
1. Use getInstance
2. Use getBool to set true or false depeding on  the first time use or not
3. If  bool is true, then end the user to the homescreen else send him to the loginscreen
4. We would need to initialize this method in initState() because this method does not return a widget and it cant be used in the build method
 */

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}


class _WelcomeScreenState extends State<WelcomeScreen> {
  String userPhoneNo;//declaring userPhoneNo and useName so they can be used later to be sent to Home()
  String userName;

  @override
  Widget build(BuildContext context) {
    return Welcome();
  }

  @override
  void initState() {
    print("userName before startTime: $userName");
    print("userPhoneNo before startTime: $userPhoneNo");
    startTime(context);
    super.initState();
  }


  /*
  Home() screen requires required parameters userName and userPhoneNo
  The problem is how do we get this data from 💬
  save the phone number from the login screen to the sharedpreferences as
  well as the name from the name screen.
   */

  startTime(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime');
    userPhoneNo = prefs.getString('userPhoneNo') ?? null;
    userName = prefs.getString('userName') ?? null;

    print("userName in startTime: $userName ");
    print("userPhoneNo in startTime: $userPhoneNo ");

    var duration = new Duration(seconds: 3);

    if ((isFirstTime != null && userName != null && userPhoneNo!=null) && isFirstTime==true) {// orginral inspiration value !isFirstTime
      return Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Home(userPhoneNo: userPhoneNo,userName: userName,), //pass Name() here and pass Home()in name_screen
          )
      );
      //return new Timer(duration,navigateToHomePage);
    }
      prefs.setBool('isFirstTime', true);// the inspiration page actually has this value as false
       return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LoginScreen(), //pass Name() here and pass Home()in name_screen
            )
        );
      //return new Timer(duration, navigateToLoginPage);

  }

  void navigateToLoginPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LoginScreen(), //pass Name() here and pass Home()in name_screen
        )
    );
  }

  void navigateToHomePage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Home(userPhoneNo: userPhoneNo,userName: userName,), //pass Name() here and pass Home()in name_screen
        )
    );
  }

}

