import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/cutomMaps/generateMapUI.dart';

class CustomMap extends StatelessWidget {
  final double latitude;
  final double longitude;

  Set<Marker> markerSet = new HashSet();
  int markerIdCounter = 1;

  final bool showRadius;
  Set<Circle> circleSet = new HashSet();
  double radius = 300; /// this would be flexible
  int circleIdCounter = 1;

  CustomMap({this.showRadius, this.latitude, this.longitude,});

  @override
  Widget build(BuildContext context) {
    print("lat in customMap : $latitude");
    return Scaffold(
      //appBar: MapAppBar(),
      body: Stack(
        children: <Widget>[
          GenerateMapUI(
            latitude: latitude,
            longitude: longitude,
            circleSet: circleSet,
            circleIdCounter: circleIdCounter,
            radius: radius,
            showRadius: showRadius,
            markerIdCounter: markerIdCounter,
            markerSet: markerSet,
          ),
//          Align(
//            alignment: Alignment.bottomCenter,
//            child: Visibility(
//              visible: showCircle == true || showCircle != null,
//              child: Row(
//                children: <Widget>[
//                  PlusButton(
                    /// onPressed :
                    /// setState radius = radius + 10
//                  ),
//                  MinusButton(),
//                ],
//              ),
//            ),
//          ),

        ],
      ),
    );
  }
}
