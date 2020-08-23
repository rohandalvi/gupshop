import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/home/home.dart';
import 'package:gupshop/onboarding/name_screen.dart';
import 'package:gupshop/service/auth_service.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/widgets/countryCodeAndFlag.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customTextFormField.dart';
import 'package:shared_preferences/shared_preferences.dart';

//LoginScreen => NameScreen
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool codeSent = false;
  String val="";
  String countryCode = '+91';
  String numberWithoutCode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Scaffold==>Column==>Stack==>Container==>Text(Gup)
      //                         ==>Container==>Text(Shup)
      //Alternatively:
      //Scaffold==>Column==>Container==>Text(Gup)
      //                 ==>Container==>Text(Shup)
      //can also be done, but the padding alignment is much beautiful with Stack
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                    Container(
                      width: 200,
                      height: 200,
                      child:
                      Image(
                        image: AssetImage('images/chatBubble.png'),
                      ),
                  ),
                  Container(
                    child: CustomText(text: 'Gup',).welcomeTitle(),
                    padding: EdgeInsets.fromLTRB(15, 120, 0, 0),
                    /// padding: EdgeInsets.fromLTRB(35, 110, 0, 0)==>if this is not included
                    /// then the words gup shup would be displayed in the upper left corner
                    /// of the screen
                  ),
                  Container(
                    child: CustomText(text: 'Shup',).welcomeTitle(),
                    padding: EdgeInsets.fromLTRB(50, 190, 0, 0),
                  )
                ],
              ),
              Row(
//                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  CountryCodeAndFlag(
                    onChanged: (value){
                      String convertedCountryCode = value.toString();
                      setState(() {
                        countryCode = convertedCountryCode;
                      });

                    },
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.25,
                      child: CustomTextFormField(
                        maxLength: 10,
                            labelText: "Enter your Number",
                            onChanged: (val) {
                              setState(() {
                                this.phoneNo = val;
                                this.val=val;
                                numberWithoutCode = this.val;
                              });
                            },
                          ),
                      padding: EdgeInsets.only(left: 20, top: 35, right: 20),
                    ),
                  ),
                ],
              ),
              CustomIconButton(
                onPressed: verifyphone,
                iconNameInImageFolder: 'nextArrow',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String phoneNo, verificationId, smsCode;

  Future<void> verifyphone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userPhoneNo = prefs.getString('userPhoneNo');
    print("userPhoneNo in verifyPhone: $userPhoneNo");

    setState(() {
      val = countryCode + numberWithoutCode;
    });

    /// I dont think PhoneVerificationCompleted PhoneVerificationFailed is required @todo
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed = (AuthException authException) {
    };
    /// seperator


    final PhoneCodeSent smsSent = (String verId, [int forceResend]) async{
      print("Received verification id ${verId}");
      this.verificationId = verId;

      setState(() {
        this.codeSent = true;
        print("val : $val");
        prefs.setString('userPhoneNo', val);
      });

        print("userPhoneNo in login_screen setState: $val");

        bool sms = await  smsCodeDialog(context);
        AuthCredential authCredential = PhoneAuthProvider.getCredential(verificationId: this.verificationId, smsCode: this.smsCode);

        FirebaseAuth.instance.signInWithCredential(authCredential).then( (user) {
          //Navigator.of(context).pushNamed('loggedIn');

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NameScreen(userPhoneNo:val),//pass Name() here and pass Home()in name_screen
              )
          );
          print("phone no: ${val.toString()}");

        }).catchError((e) {
          Flushbar( /// for the flushBar if the user enters wrong verification code
            icon: SvgPicture.asset(
              'images/stopHand.svg',
              width: 30,
              height: 30,
            ),
            flushbarStyle: FlushbarStyle.GROUNDED,
            backgroundColor: Colors.white,
            duration: Duration(seconds: 5),
            forwardAnimationCurve: Curves.decelerate,
            reverseAnimationCurve: Curves.easeOut,
            titleText: CustomText(text: 'Wrong verification code',),
            message: "Please enter your name to move forward",
          )..show(context);
        });









//      setState(() {
//        this.codeSent = true;
//        print("val : $val");
//        prefs.setString('userPhoneNo', val);
//
//        print("userPhoneNo in login_screen setState: $val");
//        smsCodeDialog(context).then((value) {
//        //smsCodeDialog(context).then((value) {
//          print("Got value $value");
//          AuthCredential authCredential = PhoneAuthProvider.getCredential(verificationId: this.verificationId, smsCode: this.smsCode);
//
//          //add userPhoneNumber to our database. Add to the users collection:
//          Firestore.instance.collection("recentChats").document(val).setData({});
//
//          //creating a document with the user's phone number in profilePictures collection which would have no data set for the profile picture itself if the  user logs in for the first time, later he can add the profile picture  himself
//          Firestore.instance.collection("profilePictures").document(val).setData({});
//
//          Firestore.instance.collection("friends_$userPhoneNo").document(val).setData({});///check
//
//
//
//          FirebaseAuth.instance.signInWithCredential(authCredential).then( (user) {
//            //Navigator.of(context).pushNamed('loggedIn');
//            print("userphoneno: ${val}");
//            Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => NameScreen(userPhoneNo:val),//pass Name() here and pass Home()in name_screen
//                )
//            );
//            print("phone no: ${val.toString()}");
//
//          }).catchError((e) {
//            print("Got error $e");
//          });
//        });
//      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    print("Calling verifyPhone Number");
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: val,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }



  Future<bool> smsCodeDialog(BuildContext context) {
    //the method for displaying the dialog box which pops up to put the sms code
    //sent to the user for verification
    print("in smsCodeDialog");

    return showDialog(
        context: context, //@Todo-why??
        barrierDismissible: false, //@Todo-why??
        builder: (BuildContext context) {
          return new AlertDialog(
            title: CustomText(text: 'Enter sms code',),
            content: TextField(
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            actions: <Widget>[
              FlatButton(
                child:CustomText(text: 'Ok',),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

}