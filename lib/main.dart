import 'package:flutter/material.dart';
import 'package:gupshop/models/chat_List.dart';
import 'package:gupshop/screens/bazaarHome_screen.dart';
import 'package:gupshop/screens/bazaarIndividualCategoryList.dart';
import 'package:gupshop/screens/bazaarProfilePage.dart';
import 'package:gupshop/screens/contacts.dart';
import 'package:gupshop/screens/home.dart';
import 'package:gupshop/screens/home_screen.dart';
import 'package:gupshop/screens/individual_chat.dart';
import 'package:gupshop/screens/login_screen.dart';
import 'package:gupshop/screens/name_screen.dart';
import 'package:gupshop/screens/productDetail.dart';
import 'package:gupshop/screens/welcomeScreen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.lightGreen,
//        primaryColor: Colors.grey,
        accentColor: Colors.cyan[50],
      ),
      title: 'Chat home',
//      home: Home(),
//      home: LoginScreen(),
      home: WelcomeScreen(),
//        home: HomeScreen(),
//        home: BazaarProfilePage(),
//      home: ProductDetail(),
//        home: BazaarHomeScreen(),
//      home: BazaarIndividualCategoryList(),
//        home: NameScreen(),
//      home: IndividualChat(),
//      routes: <String, WidgetBuilder>{
//        "loggedIn": (BuildContext context) => new Home(),
//        "individualChat": (BuildContext context) => new IndividualChat(),
//      },
    );
  }
}
