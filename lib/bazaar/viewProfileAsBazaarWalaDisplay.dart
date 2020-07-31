import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/viewProfileAsBazaarWalaData.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customText.dart';

class ViewProfileAsBazaarWalaDisplay extends StatefulWidget {
  @override
  _ViewProfileAsBazaarWalaDisplayState createState() => _ViewProfileAsBazaarWalaDisplayState();
}

class _ViewProfileAsBazaarWalaDisplayState extends State<ViewProfileAsBazaarWalaDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: CustomAppBar(
            title: CustomText(text: 'View Profile as :',),
          ).noLeading(),
      ),
      body: ViewProfileAsBazaarWalaData(),
    );
  }
}
