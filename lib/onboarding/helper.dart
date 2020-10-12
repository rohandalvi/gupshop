//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:gupshop/modules/userDetails.dart';
//import 'package:gupshop/onboarding/welcomeScreen.dart';
//import 'package:gupshop/passcode/customAppLock.dart';
//import 'package:gupshop/passcode/unlockPasscode.dart';
//import 'package:gupshop/retriveFromFirebase/conversationMetaData.dart';
//
//class Helper extends StatelessWidget {
//
//  @override
//  Widget build(BuildContext context) {
//    return FutureBuilder(
//      future: UserDetails().getPasscodeStatus(),
//      builder: (context, snapshot) {
//        if(snapshot.connectionState == ConnectionState.done){
//          bool passcodeEnabled = snapshot.data;
//          if(passcodeEnabled == true){
//            return CustomAppLock(
//              lockScreen: UnlockPasscode(
//                isValidCallback: ,
//              ),
//            );
//            return FutureBuilder(
//              future: passcodeUnlocked(context),
//              builder: (context, snapshot) {
//                if(snapshot.connectionState == ConnectionState.done){
//                  bool passcodeUnlockedBool = snapshot.data;
//                  if(passcodeUnlockedBool == true){
//                    return WelcomeScreen();
//                  }return CircularProgressIndicator();
//                }
//                return CircularProgressIndicator();
//              }
//            );
//          }return WelcomeScreen();
//        }return CircularProgressIndicator();
//
//      }
//    );
//  }
//
//  passcodeUnlocked(BuildContext context) async{
//   return await Navigator.push(
//        context,
//        MaterialPageRoute(
//          builder: (context) => CustomAppLock(
//              lockScreen: UnlockPasscode()
//          ),//pass Name() here and pass Home()in name_screen
//        )
//    );
//
//  }
//}
