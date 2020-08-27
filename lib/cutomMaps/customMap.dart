import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/cutomMaps/MapAppBar.dart';
import 'package:gupshop/cutomMaps/generateMapUI.dart';
import 'package:gupshop/cutomMaps/setCircleData.dart';
import 'package:gupshop/cutomMaps/setMarkerData.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customIconButton.dart';
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

  double radius = 300;
 /// this would be flexible
  int circleIdCounter = 1;
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
              resetSetCircle(newCoordinates);
            },
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

  resetLocation(double newLatitude, double newLongitude){
    setState(() {
      widget.latitude = newLatitude;
      widget.longitude = newLongitude;
    });
  }

  resetSetCircle(LatLng point){
    if(widget.showRadius == true){
      circleSet = SetCircleData(
        point: point,
        circleSet: circleSet,
        radius: radius,
        circleIdCounter: circleIdCounter,
      ).main();

      markerSet = SetMarkerData(
          point: point,
          markerIdCounter: markerIdCounter,
          markerSet: markerSet
      ).main();
    }else{
      markerSet = SetMarkerData(
          point: point,
          markerIdCounter: markerIdCounter,
          markerSet: markerSet
      ).main();
    }
  }
}
