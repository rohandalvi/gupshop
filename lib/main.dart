import 'package:flutter/material.dart';
import 'package:gupshop/screens/login_screen.dart';
import 'package:gupshop/screens/name_screen.dart';
import 'package:gupshop/screens/welcomeScreen.dart';
import 'package:gupshop/widgets/bazaarHomeGridView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
//        home: CreateFriendsCollection(),
//        home: ContactSearch(),
//        home: SideMenu(),
//        home: ChangeProfilePicture(),
//      home: WelcomeScreen(),
//        home: HomeScreen(),
      //home: BazaarProfilePage(),
//      home: ProductDetail(),
//        home: BazaarHomeScreen(),
//      home: BazaarIndividualCategoryList(),
////        home: FilterBazaarWalas(),
//        home: NameScreen(),
//      home: IndividualChat(),
//      routes: <String, WidgetBuilder>{
//        "loggedIn": (BuildContext context) => new Home(),
//        "individualChat": (BuildContext context) => new IndividualChat(),
//      },
    );
  }
}
