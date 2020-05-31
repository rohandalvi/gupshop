import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/screens/changeProfilePicture.dart';
import 'package:gupshop/service/imagePickersDisplayPicturesFromURLorFile.dart';
import 'package:gupshop/service/profilePictureAndButtonsScreen.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

//=>LoginScreen => NameScreen => Home

class NameScreen extends StatefulWidget {
  final String userPhoneNo;
  String userName;

  NameScreen({@required this.userPhoneNo});

  @override
  _NameScreenState createState() => _NameScreenState(userPhoneNo: userPhoneNo);
}

class _NameScreenState extends State<NameScreen> {
  String userName;

  final String userPhoneNo;

  String imageUrl = "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/%2B15857547599ProfilePicture?alt=media&token=0a4a79f5-7989-4e14-8927-7b4ca39af7d7";

  _NameScreenState({@required this.userPhoneNo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child:
          Column(
            children: <Widget>[
              Container(
                child: new TextField(
                  decoration: new InputDecoration(labelText: "Enter your Name"),
                  keyboardType: TextInputType.text,
                  onChanged: (name){
                    setState(() {
                      this.userName= name;
                    });
                  },
                  // Only numbers can be entered
                ),
                padding: EdgeInsets.only(left: 20, top: 35, right: 20),
              ),
              CustomRaisedButton(
                onPressed: ()async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String userNameForSP = prefs.getString('userName');
                  print("userNameForSP in name_screen: $userNameForSP");

                  /*
                  Add first time user’s number to database:
                  For adding data, we need to use set() method
                  We dont have userPhone and name both at the login_screen, we get both
                  of them in the name_screen, so we will add them in that file only.
                   */
                  Firestore.instance.collection("users").document(userPhoneNo).setData({'name':userName});
                  print("Firestore.instance.collection(users).document(userPhoneNo).setData({'name':userName}):${userName}");
                  setState(() {
                    prefs.setString('userName', userName);
                    print("userNameForSP in name_screen setState: $userName");
                    print("userphoneno in name screen : $userPhoneNo");
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(userPhoneNo: userPhoneNo, userName: userName),//pass Name() here and pass Home()in name_screen
                      )
                  );
                },
                //a method is created for this variable down
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //ProfilePictureAndButtonsScreen(userPhoneNo: userPhoneNo, imageUrl: imageUrl, displayPicture: true,applyButtons: true,allowListView: false,)
            ],
          ),
        ),
      ),
    );
  }
}
