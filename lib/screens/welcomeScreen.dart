import 'package:flutter/material.dart';
import 'package:gupshop/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}


/*
Just use the getInstance() from SharedPreferences
Use Futurebuilder for it, because it is a promise
Give the getInstance() data to the future
Give the context and AsyncSnapshot of sharedPreferences to the builder
Check the connectionstate:
If connectionState if none/waiting ⇒ return loading screen
Else default it to :
=>If snapshot has no error:
Return homescreeen
=>If it has error
Return ErrorScreen
 */
class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:{return CircularProgressIndicator();}
            case ConnectionState.waiting: {return CircularProgressIndicator();}
            default:{
              if(!snapshot.hasError){
                if(snapshot.data != null){return Home();}
                return LoginScreen();
              }
              print("Error: ${snapshot}");
              return new Text("Error loading data");
          }
          }
        }
    );
  }
}
