import 'package:flutter/material.dart';
import 'package:gupshop/models/chat_List.dart';
import 'package:gupshop/screens/contacts.dart';
import 'package:gupshop/screens/home.dart';
import 'package:gupshop/screens/individual_chat.dart';
import 'package:gupshop/screens/login_screen.dart';
import 'package:gupshop/screens/name_screen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.lightGreen,
        accentColor: Color(0xFFFEF9EB),
      ),
      title: 'Chat home',
//      home: IndividualChat(),
      home: LoginScreen(),
//        home: NameScreen(),
//      home: IndividualChat(),
//      routes: <String, WidgetBuilder>{
//        "loggedIn": (BuildContext context) => new Home(),
//        "individualChat": (BuildContext context) => new IndividualChat(),
//      },
    );
  }
}
