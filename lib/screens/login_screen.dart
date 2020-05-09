import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gupshop/screens/home.dart';
import 'package:gupshop/screens/name_screen.dart';
import 'package:gupshop/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool codeSent = false;
  String val="";

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
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                child: Text(
                  'Gup',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 90,
                  ),
                ),
                padding: EdgeInsets.fromLTRB(15, 110, 0, 0),
                // padding: EdgeInsets.fromLTRB(35, 110, 0, 0)==>if this is not included
                // then the words gup shup would be displayed in the upper left corner
                // of the screen
              ),
              Container(
                child: Text(
                  'Shop',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 90,
                  ),
                ),
                padding: EdgeInsets.fromLTRB(50, 190, 0, 0),
              )
            ],
          ),
          Container(
            child: new TextField(
              decoration: new InputDecoration(labelText: "Enter your number"),
              keyboardType: TextInputType.phone,
              onChanged: (val) {

                setState(() {
                  this.phoneNo = val;
                  this.val=val;
                  //Firestore.instance.collection("recentChats").document(val.substring(2,12)).setData({});
                  print("phoneNo: ${val}");
                });
              },
              // Only numbers can be entered
            ),
            padding: EdgeInsets.only(left: 20, top: 35, right: 20),
          ),
          RaisedButton(
            onPressed: verifyphone,
            //a method is created for this variable down
            color: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.blueGrey,
            elevation: 0,
            hoverColor: Colors.blueGrey,
            child: Text(
              'Verify',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String phoneNo, verificationId, smsCode;

  Future<void> verifyphone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userPhoneNo = prefs.getString('userPhoneNo');
    print("userPhoneNo in login_screen: $userPhoneNo");
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      print("Received verification id ${verId}");
      this.verificationId = verId;

      setState(() {
        this.codeSent = true;
        prefs.setString('userPhoneNo', val);//toDo - remove substring
        //prefs.setString('userPhoneNo', val.substring(2,12));//toDo - remove substring
        print("userPhoneNo in login_screen setState: $val");
        smsCodeDialog(context).then((value) {
          print("Got value $value");
          AuthCredential authCredential = PhoneAuthProvider.getCredential(verificationId: this.verificationId, smsCode: this.smsCode);
          //add userPhoneNumber to our database. Add to the users collection:
          Firestore.instance.collection("recentChats").document(val).setData({});//toDo - remove substring
          // Firestore.instance.collection("recentChats").document(val.substring(2,12)).setData({});//toDo - remove substring

          //creating a document with the user's phone number in profilePictures collection which would have no data set for the profile picture itself if the  user logs in for the first time, later he can add the profile picture  himself
          Firestore.instance.collection("profilePictures").document(val).setData({}, merge: true);//toDo - remove substring
          //Firestore.instance.collection("profilePictures").document(val.substring(2,12)).setData({}, merge: true);//toDo - remove substring


          FirebaseAuth.instance.signInWithCredential(authCredential).then( (user) {
            //Navigator.of(context).pushNamed('loggedIn');
            print("userphoneno: ${val}");
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NameScreen(userPhoneNo:val),//pass Name() here and pass Home()in name_screen
                )
            );
            print("phone no: ${val.toString()}");//toDo - remove substring
            //print("phone no: ${val.toString().substring(2,12)}");//toDo - remove substring
          }).catchError((e) {
            print("Got error $e");
          });
        });
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    //the method for displaying the dialog box which pops up to put the sms code
    //sent to the user for verification

    return showDialog(
        context: context, //@Todo-why??
        barrierDismissible: false, //@Todo-why??
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text(
              'Enter sms code',
            ),
            content: TextField(
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

}