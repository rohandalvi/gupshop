import 'package:flutter/material.dart';
import 'package:gupshop/screens/home.dart';
import 'package:gupshop/screens/login_screen.dart';
import 'package:gupshop/screens/name_screen.dart';
import 'package:gupshop/screens/welcomeScreen.dart';
import 'package:gupshop/group/createGroup.dart';
import 'package:gupshop/bazaar/bazaarHomeGridView.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
//        primaryColor: Colors.grey,
        accentColor: subtitleGray,
      ),
      title: 'Chat home',
      debugShowCheckedModeBanner: false,
//      home: Home(userPhoneNo: '+19194134191', userName: 'Purva Dalvi',),
//       home: GeolocationService(),
//      home: LoginScreen(),
//        home: CreateFriendsCollection(),
//        home: ContactSearch(),
//        home: SideMenu(),
//        home: ChangeProfilePicture(),
      home: WelcomeScreen(),
        //home: CustomVideoPlayer(videoURL: 'https://www.youtube.com/watch?v=V41_-PNZ92U',),
//      home: CreateGroup(),
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
