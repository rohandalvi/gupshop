import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/bazaarOnBoarding/onBoardingCategoySelector.dart';
import 'package:gupshop/bazaarOnBoarding/onBoardingHome.dart';
import 'package:gupshop/cutomMaps/generateMapUI.dart';

class NavigateToGenerateMapUI{
  double latitude;
  double longitude;

  Set<Marker> markerSet;
  int markerIdCounter;

  Set<Circle> circleSet;
  bool showRadius;
  double radius;
  int circleIdCounter;

  NavigateToGenerateMapUI({this.longitude, this.latitude, this.circleSet, this.markerSet,
    this.showRadius, this.radius, this.circleIdCounter,
    this.markerIdCounter,

  });



  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GenerateMapUI(
              latitude: latitude,
              longitude: longitude,
              circleSet: circleSet,
              circleIdCounter: circleIdCounter,
              radius: radius,
              showRadius: showRadius,
              markerIdCounter: markerIdCounter,
              markerSet: markerSet,
            ),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenerateMapUI(
            latitude: latitude,
            longitude: longitude,
            circleSet: circleSet,
            circleIdCounter: circleIdCounter,
            radius: radius,
            showRadius: showRadius,
            markerIdCounter: markerIdCounter,
            markerSet: markerSet,
          ),
        )
    );
  }
}