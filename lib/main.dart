import 'package:flutter/material.dart';
import 'package:gupshop/fahrenheitToCelcius.dart';
import 'package:gupshop/models/chat_List.dart';
import 'package:gupshop/screens/bazaarHome_screen.dart';
import 'package:gupshop/screens/bazaarIndividualCategoryList.dart';
import 'package:gupshop/screens/bazaarProfilePage.dart';
import 'package:gupshop/screens/changeProfilePicture.dart';
import 'package:gupshop/screens/contacts.dart';
import 'package:gupshop/screens/home.dart';
import 'package:gupshop/screens/home_screen.dart';
import 'package:gupshop/screens/individual_chat.dart';
import 'package:gupshop/screens/login_screen.dart';
import 'package:gupshop/screens/name_screen.dart';
import 'package:gupshop/screens/productDetail.dart';
import 'package:gupshop/screens/welcomeScreen.dart';
import 'package:gupshop/service/filterBazaarWalas.dart';
import 'package:gupshop/service/geolocation_service.dart';
import 'package:gupshop/widgets/sideMenu.dart';

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
//       home: GeolocationService(),
      home: LoginScreen(),
//        home: SideMenu(),
//        home: ChangeProfilePicture(),
//      home: WelcomeScreen(),
//        home: HomeScreen(),
        //home: BazaarProfilePage(),
//      home: ProductDetail(),
//        home: BazaarHomeScreen(),
//      home: BazaarIndividualCategoryList(),
//        home: FilterBazaarWalas(),
////        home: NameScreen(),
//      home: IndividualChat(),
//      routes: <String, WidgetBuilder>{
//        "loggedIn": (BuildContext context) => new Home(),
//        "individualChat": (BuildContext context) => new IndividualChat(),
//      },
    );
  }
}
