import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/cutomMaps/MapAppBar.dart';
import 'package:gupshop/cutomMaps/generateMapUI.dart';
import 'package:gupshop/cutomMaps/minusButton.dart';
import 'package:gupshop/cutomMaps/okButton.dart';
import 'package:gupshop/cutomMaps/plusButton.dart';
import 'package:gupshop/cutomMaps/setCircleData.dart';
import 'package:gupshop/navigators/navigateToBazaarOnBoardingProfile.dart';
import 'package:gupshop/responsive/keys.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/widgets/customFlushBar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:search_map_place/search_map_place.dart';

class CustomMap extends StatefulWidget {
  double latitude;
  double longitude;

  final bool showRadius;
  final String placeholder;

  final bool showBackButton;

  CustomMap({this.showRadius, this.latitude, this.longitude,this.placeholder, this.showBackButton});

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

  MapAppBar appBar;

  bool exit = false;


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
          appBarWidget(),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              child: Row(
                children: <Widget>[
                  Visibility(
                    visible : widget.showRadius == true,
                    child: PlusButton(
                      ///onPressed :
                      ///setState radius = radius + 10
                      onRadiusPlus: (){
                        LatLng point = LatLng(widget.latitude, widget.longitude);
                        increaseRadius(point);
                      },
                    ),
                  ),
                  Visibility(
                    visible : widget.showRadius == true,
                    child: MinusButton(
                      onRadiusMinus: (){
                        LatLng point = LatLng(widget.latitude, widget.longitude);
                        decreaseRadius(point);
                      },
                    ),
                  ),
                  OkButton(
                    onOkPressed:(){
                      LatLng point = LatLng(widget.latitude, widget.longitude);
                      List list = new List();
                      list.add(point);
                      if(widget.showRadius == true){
                        list.add(radius);
                      }
                      Navigator.pop(context, list);
                      //NavigateToBazaarOnBoardingProfile().navigateNoBracketsPushReplacement(context, list);
                    },
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.showBackButton != null || widget.showBackButton == true,
            child: CustomIconButton(
              iconNameInImageFolder: 'backArrowColor',
              onPressed: (){
                LatLng point = LatLng(widget.latitude, widget.longitude);
                List list = new List();
                list.add(point);
                if(widget.showRadius == true){
                  list.add(radius);
                }
                Navigator.pop(context, list);
              },
            ),
          ),
        ],
      ),
    );
  }

  appBarWidget(){

    appBar = new MapAppBar(
      onSelected: (place) async{
        Geolocation geoLocation = await place.geolocation;

        LatLng newCoordinates = geoLocation.coordinates;
        double newLatitude = newCoordinates.latitude;
        double newLongitude = newCoordinates.longitude;

        resetLocation(newLatitude, newLongitude);
      },
      placeholder: widget.placeholder,
    );
    //return appBar;

    return Container(
      margin: EdgeInsets.only(left: PaddingConfig.five, top: PaddingConfig.twentyFive),
      child: appBar,
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
