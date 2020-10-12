import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:gupshop/notifications/NotificationEventType.dart';
import 'package:gupshop/notifications/NotificationsManager.dart';
import 'package:gupshop/notifications/models/NotificationRequest.dart';
import 'package:gupshop/onboarding/login_screen.dart';
import 'package:gupshop/onboarding/welcome.dart';
import 'package:gupshop/passcode/customAppLock.dart';
import 'package:gupshop/passcode/unlockPasscode.dart';
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
  final bool lockEnabled;

  WelcomeScreen({this.lockEnabled});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String userPhoneNo; //declaring userPhoneNo and useName so they can be used later to be sent to Home()
  String userName;
  bool unLockedStatus;

  @override
  Widget build(BuildContext context) {
    // TODO - remove this example and move it to a more solid class in the next commit
//     initNotifications();

  return FutureBuilder(
    future: startTime(context),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if(snapshot.data == true){
          if(widget.lockEnabled){
            return CustomAppLock(
              lockScreen: UnlockPasscode(
                isValidCallback: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(userPhoneNo: userPhoneNo,
                          userName: userName,),//pass Name() here and pass Home()in name_screen
                      )
                  );
                },
              ),
            );
          }else return Home(userPhoneNo: userPhoneNo,
            userName: userName,);

        }else{
          return LoginScreen();
        }
      }
      return Center(
        child: Welcome(),
      );
    },
  );
  }

  appLock(){
//   bool result = await Navigator.push(
//        context,
//        MaterialPageRoute(
//          builder: (context) => CustomAppLock(
//            lockScreen:
//            UnlockPasscode(
//              didUnLock: (result) {
//                setState(() {
//                  unLockedStatus = result;
//                });
//              },
//            ),
//          ),//pass Name() here and pass Home()in name_screen
//        )
//    );
//   if(result == true){
//     return Home(
//       userPhoneNo: userPhoneNo,
//       userName: userName,
//     );
//   }



    if(unLockedStatus == true){
     return Home(
       userPhoneNo: userPhoneNo,
       userName: userName,
     );
   }
  }

  @override
  void initState() {
    print("AppLock state Welcome: ${AppLock.of(context)}");
    print("userName before startTime: $userName");
    print("userPhoneNo before startTime: $userPhoneNo");
//    startTime(context);

    super.initState();
  }

  /*
  Home() screen requires required parameters userName and userPhoneNo
  The problem is how do we get this data from 💬
  save the phone number from the login screen to the sharedpreferences as
  well as the name from the name screen.
   */

  Future<bool> startTime(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime');
    userPhoneNo = prefs.getString('userPhoneNo') ?? null;
    userName = prefs.getString('userName') ?? null;

    /// Home screen:
    if ((isFirstTime != null && userName != null && userPhoneNo != null) &&
        isFirstTime == true) {
      return true;
    } /// loginScreen:
    prefs.setBool('isFirstTime', true); // the inspiration page actually has this value as false
    return false;
  }


//  startTime(BuildContext context) async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    bool isFirstTime = prefs.getBool('isFirstTime');
//    userPhoneNo = prefs.getString('userPhoneNo') ?? null;
//    userName = prefs.getString('userName') ?? null;
//
//    print("userName in startTime: $userName ");
//    print("userPhoneNo in startTime: $userPhoneNo ");
//
////    var duration = new Duration(seconds: 3);
//
//    /// Home screen:
//    if ((isFirstTime != null && userName != null && userPhoneNo != null) &&
//        isFirstTime == true) {
//      // orginral inspiration value !isFirstTime
//      return Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) => Home(
//              userPhoneNo: userPhoneNo,
//              userName: userName,
//            ), //pass Name() here and pass Home()in name_screen
//          ));
//    } /// loginScreen:
//    prefs.setBool('isFirstTime', true); // the inspiration page actually has this value as false
//    return Navigator.push(
//        context,
//        MaterialPageRoute(
//          builder: (context) =>
//              LoginScreen(), //pass Name() here and pass Home()in name_screen
//        ));
//    //return new Timer(duration, navigateToLoginPage);
//  }

//  void navigateToLoginPage() {
//    Navigator.push(
//        context,
//        MaterialPageRoute(
//          builder: (context) =>
//              LoginScreen(), //pass Name() here and pass Home()in name_screen
//        ));
//  }
//
//  void navigateToHomePage() {
//    Navigator.push(
//        context,
//        MaterialPageRoute(
//          builder: (context) => Home(
//            userPhoneNo: userPhoneNo,
//            userName: userName,
//          ), //pass Name() here and pass Home()in name_screen
//        ));
//  }

//  Map<String, dynamic> _getNotificationData() {
//    Map<String, dynamic> map = new Map<String, dynamic>();
//    map['body'] = 'Test';
//    map['title'] = 'Test title';
//    return map;
//  }
//
//  Map<String, dynamic> _getRequestData() {
//    Map<String, dynamic> map = new Map<String, dynamic>();
//    map['type'] = NotificationEventType.VIDEO_CALL.toString();
//    return map;
//  }
//
//  Map<String, String> _getHeaders() {
//    Map<String, String> map = new Map<String, String>();
//    map['Content-Type'] = 'application/json';
//    return map;
//  }


  void initNotifications() async {
    NotificationsManager notificationsManager = new NotificationsManager(
      /// when app is in foreground
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          /// when app is terminated
        }, onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
      /// when app is resumed
    }, onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
    });

    NotificationRequest notificationRequest = NotificationRequestBuilder()
        .setRequestHeader(new RequestHeaderBuilder()
        .setContentType('application/json')
        .build())
        .setNotificationHeader(new NotificationHeaderBuilder()
        .setBody('TestBody')
        .setTitle('testTitle')
        .build())
        .setNotificationData(new NotificationDataBuilder().setData('type', NotificationEventType.VIDEO_CALL.toString()).build())
        .build();

    notificationsManager
        .sendNotification(notificationRequest, await notificationsManager.getToken());
  }
}
