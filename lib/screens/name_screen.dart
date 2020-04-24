import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

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

  _NameScreenState({@required this.userPhoneNo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
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
              RaisedButton(
                onPressed: ()async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String userNameForSP = prefs.getString('userName');
                  print("userNameForSP in name_screen: $userNameForSP");
                  setState(() {
                    prefs.setString('userName', userName);
                    print("userNameForSP in name_screen setState: $userName");
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(userPhoneNo: userPhoneNo.substring(2,12), userName: userName),//pass Name() here and pass Home()in name_screen
                      )
                  );
                },
                //a method is created for this variable down
                color: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.blueGrey,
                elevation: 0,
                hoverColor: Colors.blueGrey,
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


//return MaterialApp(
//home: Scaffold(
//backgroundColor: Colors.white,
//body: Center(
//child: Column(
//children: <Widget>[
//Container(
//child: TextField(
//
//),
//),
//RaisedButton(
//onPressed: (){},
////a method is created for this variable down
//color: Colors.transparent,
//splashColor: Colors.transparent,
//highlightColor: Colors.blueGrey,
//elevation: 0,
//hoverColor: Colors.blueGrey,
//child: Text(
//'Verify',
//style: TextStyle(
//color: Theme.of(context).primaryColor,
//fontSize: 15,
//fontWeight: FontWeight.bold,
//),
//),
//),
//],
//),
//),
//),
//);