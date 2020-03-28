import 'package:flutter/material.dart';
import 'package:gupshop/screens/home_screen.dart';
import 'package:gupshop/screens/login_screen.dart';

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
      //home: HomeScreen(),
       home: LoginScreen(),
      routes: <String, WidgetBuilder>{
        "loggedIn": (BuildContext context) => new HomeScreen()
      },
    );
  }
}

