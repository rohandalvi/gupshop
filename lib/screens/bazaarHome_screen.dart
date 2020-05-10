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
import 'package:gupshop/widgets/bazaarHomeGridView.dart';

class BazaarHomeScreen extends StatefulWidget {
  @override
  _BazaarHomeScreenState createState() => _BazaarHomeScreenState();
}

class _BazaarHomeScreenState extends State<BazaarHomeScreen> {

  setUsersLocationToFirebase() async{
    var userPhoneNo = await GetSharedPreferences().getUserPhoneNoFuture();//get user phone no
    var ifHomeExists;

    //if home location is not set then go on with setting the location
    var future = await Firestore.instance.collection("usersLocation").document(userPhoneNo).get();
    print("home: ${future.data["home"]}");
    if(future.data["home"] != null){
      ifHomeExists= true;
    }ifHomeExists = false;



   if(ifHomeExists == false) {
     Position location = await GeolocationServiceState().getLocation();
     var latitude = location.latitude;
     var longitude = location.longitude;

     var address = await GeolocationServiceState().getAddress();

     GeolocationServiceState().pushUsersLocationToFirebase(latitude, longitude, userPhoneNo, "home", address); //pass a name for the location also as a parameter

     print("location set");
   }

  }

  @override
  void initState() {
    super.initState();

    setUsersLocationToFirebase();
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
              builder: (context) => BazaarProfilePage(),//pass Name() here and pass Home()in name_screen
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