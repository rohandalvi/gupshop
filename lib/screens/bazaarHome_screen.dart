//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/screens/bazaarProfilePage.dart';
import 'package:gupshop/service/geolocation_service.dart';
import 'package:gupshop/service/getSharedPreferences.dart';
import 'package:gupshop/service/usersLocation.dart';
import 'package:gupshop/widgets/bazaarHomeGridView.dart';

// home.dart =>
// => bazaarProfilePage
class BazaarHomeScreen extends StatefulWidget {
  final String userPhoneNo;
  final String userName;

  BazaarHomeScreen({@required this.userPhoneNo, @required this.userName});

  @override
  _BazaarHomeScreenState createState() => _BazaarHomeScreenState(userPhoneNo: userPhoneNo, userName: userName);
}

class _BazaarHomeScreenState extends State<BazaarHomeScreen> {

  final String userPhoneNo;
  final String userName;

  _BazaarHomeScreenState({@required this.userPhoneNo, @required this.userName});

  @override
  void initState() {
    super.initState();

    UsersLocation().setUsersLocationToFirebase();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(height: 12,),
          new BazaarHomeGridView(),
        ],
      ),
      floatingActionButton: _floatingActionButtonForNewBazaarwala(),
    );
  }


  _floatingActionButtonForNewBazaarwala(){
    return FloatingActionButton(
      child: IconButton(
        icon: Icon(Icons.add),
      ),
      onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BazaarProfilePage(userPhoneNo: userPhoneNo, userName: userName,),//pass Name() here and pass Home()in name_screen
            )
        );
      },
    );
  }
}


//Padding(
//padding: EdgeInsets.only(left: 16, right: 16),
//child: Row(
//mainAxisAlignment: MainAxisAlignment.spaceBetween,
//children: <Widget>[
//Column(
//crossAxisAlignment: CrossAxisAlignment.start,
//children: <Widget>[
//Text(
//"Category1",
//style: GoogleFonts.openSans(
//textStyle: TextStyle(
//fontSize: 18,
//fontWeight: FontWeight.bold,
//),
//),
//),
//SizedBox(height: 4,),
//Text(
//"Category1",
//style: GoogleFonts.openSans(
//textStyle: TextStyle(
//fontSize: 18,
//fontWeight: FontWeight.bold,
//),
//),
//),
//],
//),
//IconButton(
//alignment: Alignment.topCenter,
//icon: Icon(Icons.add),
//),
//],
//),
//),