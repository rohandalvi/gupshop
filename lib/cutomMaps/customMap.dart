import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/cutomMaps/MapAppBar.dart';
import 'package:gupshop/cutomMaps/generateMapUI.dart';
import 'package:gupshop/cutomMaps/minusButton.dart';
import 'package:gupshop/cutomMaps/plusButton.dart';
import 'package:gupshop/cutomMaps/setCircleData.dart';
import 'package:gupshop/widgets/customFlushBar.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:search_map_place/search_map_place.dart';

class CustomMap extends StatefulWidget {
  double latitude;
  double longitude;

  final bool showRadius;

  CustomMap({this.showRadius, this.latitude, this.longitude,});

  @override
  _CustomMapState createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  Set<Marker> markerSet = new HashSet();

  int markerIdCounter = 1;

  Set<Circle> circleSet = new HashSet();

  /// this would be flexible
  double radiusUpperLimit = 900;
  double radiusLowerLimit = 100;
  double radius = 300;
  double radiusChange= 100;

  int circleIdCounter = 1;




  @override
  void didUpdateWidget(CustomMap oldWidget) {
    super.didUpdateWidget(oldWidget);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GenerateMapUI(
            latitude: widget.latitude,
            longitude: widget.longitude,
            circleSet: circleSet,
            circleIdCounter: circleIdCounter,
            radius: radius,
            showRadius: widget.showRadius,
            markerIdCounter: markerIdCounter,
            markerSet: markerSet,
          ),
          MapAppBar(
            onSelected: (place) async{
              Geolocation geoLocation = await place.geolocation;

              LatLng newCoordinates = geoLocation.coordinates;
              double newLatitude = newCoordinates.latitude;
              double newLongitude = newCoordinates.longitude;

              resetLocation(newLatitude, newLongitude);

            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Visibility(
              visible: widget.showRadius == true || widget.showRadius != null,
              child: Row(
                children: <Widget>[
                  PlusButton(
                    ///onPressed :
                    ///setState radius = radius + 10
                    onRadiusPlus: (){
                      LatLng point = LatLng(widget.latitude, widget.longitude);
                      increaseRadius(point);
                    },
                  ),
                  MinusButton(
                    onRadiusMinus: (){
                      LatLng point = LatLng(widget.latitude, widget.longitude);
                      decreaseRadius(point);
                    },
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  resetLocation(double newLatitude, double newLongitude){
    setState(() {
      widget.latitude = newLatitude;
      widget.longitude = newLongitude;
    });
  }


  increaseRadius(LatLng point){
    if(radius < radiusUpperLimit ){
      setState(() {
        radius = radius + radiusChange;
        circleSet = SetCircleData(
          point: point,
          radius: radius,
          circleIdCounter: circleIdCounter,
        ).main();
      });
    }else{
      return CustomFlushBar(
        customContext: context,
        iconName: 'speaker',
        text: CustomText(
          text: 'This is the maximum service area',
        ),
        message: 'This is the maximum service area',
      ).showFlushBar();
    }

  }

  decreaseRadius(LatLng point){
    if(radius >= radiusLowerLimit ){
      setState(() {
        radius = radius - radiusChange;
        circleSet = SetCircleData(
          point: point,
          radius: radius,
          circleIdCounter: circleIdCounter,
        ).main();
      });
    }else{
      return CustomFlushBar(
        customContext: context,
        iconName: 'speaker',
        text: CustomText(
          text: 'This is the minimum service area',
        ),
        message: 'This is the minimum service area',
      ).showFlushBar();
    }


  }
}
