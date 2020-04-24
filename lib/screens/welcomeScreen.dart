import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gupshop/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}


class _WelcomeScreenState extends State<WelcomeScreen> {
  String userPhoneNo;//declaring userPhoneNo and useName so they can be used later to be sent to Home()
  String userName;

  @override
  Widget build(BuildContext context) {
    return Material();
  }

  @override
  void initState() {
    print("userName before startTime: $userName");
    print("userPhoneNo before startTime: $userPhoneNo");
    startTime();
    print("initState");
    super.initState();
  }


  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime');
    userPhoneNo = prefs.getString('userPhoneNo');
    userName = prefs.getString('userName');

    print("userName in startTime: $userName ");
    print("userPhoneNo in startTime: $userPhoneNo ");

    var duration = new Duration(seconds: 3);

    if ((isFirstTime != null && userName != null && userPhoneNo!=null) && isFirstTime==true) {// orginral inspiration value !isFirstTime
      return new Timer(duration,navigateToHomePage);
    }
      prefs.setBool('isFirstTime', true);// the inspiration page actually has this value as false
      return new Timer(duration, navigateToLoginPage);

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
//  int number;
//  bool firstTime;
//  final pref= SharedPreferences.getInstance();
//
//  Future<bool> getPref() async{
//    pref = await SharedPreferences.getInstance();
//    firstTime = pref.getBool('firstTime')??0;
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    print("pref: $pref");
//    return new FutureBuilder(
//        future: SharedPreferences.getInstance(),
//        builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot){
//          switch(snapshot.connectionState){
//            case ConnectionState.none:{return CircularProgressIndicator();}
//            case ConnectionState.waiting: {return CircularProgressIndicator();}
//            default:{
//              print("SharedPreferences.getInstance(): ${SharedPreferences.getInstance()}");
//              firstTime = snapshot.getBool('firstTime')??false;
//              print("firstTime: $firstTime");
//              if(!snapshot.hasError){
//                print("snapshot: $snapshot");
//                if(snapshot.data != null){return Home();}//Return homescreeen(if user is not firstTime),
//                return LoginScreen();//Return loginScreen(if user is firstTime)
//              }
//              print("Error: $snapshot");
//              return new Text("Error loading data");
//          }
//          }
//        }
//    );

