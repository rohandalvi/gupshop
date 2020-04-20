import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/widgets/bazaarHomeGridView.dart';

class BazaarHomeScreen extends StatefulWidget {
  @override
  _BazaarHomeScreenState createState() => _BazaarHomeScreenState();
}

class _BazaarHomeScreenState extends State<BazaarHomeScreen> {
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