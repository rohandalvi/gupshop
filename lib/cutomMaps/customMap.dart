import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/cutomMaps/MapAppBar.dart';
import 'package:gupshop/cutomMaps/generateMapUI.dart';
import 'package:gupshop/cutomMaps/minusButton.dart';
import 'package:gupshop/cutomMaps/okButton.dart';
import 'package:gupshop/cutomMaps/plusButton.dart';
import 'package:gupshop/cutomMaps/setCircleData.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/intConfig.dart';
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
  double radiusUpperLimit = IntConfig.radiusUpperLimit;
  double radiusLowerLimit = IntConfig.radiusLowerLimit;
  double radius = IntConfig.radius;
  double radiusChange= IntConfig.radiusChange;

  int circleIdCounter = 1;

  MapAppBar appBar;

  bool exit = false;
  double zoom;


  @override
  void didUpdateWidget(CustomMap oldWidget) {
    print("in customMap didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    zoom = IntConfig.zoom;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    print("in customMaps : $zoom");
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
            zoom: zoom,
          ),
          appBarWidget(),

          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
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
          ),
          Visibility(
            visible: widget.showBackButton != null || widget.showBackButton == true,
            child: CustomIconButton(
              iconNameInImageFolder: IconConfig.backArrow,
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

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: PaddingConfig.five, ),///top: PaddingConfig.twentyFive
        child: appBar,
      ),
    );

  }


  /// selecting new location
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
        if(zoom > IntConfig.zoomLimit){/// 10.55
          zoom = zoom - IntConfig.zoomChange;
        }
        if(radius > IntConfig.radiusHitsScreenFrom && radius < IntConfig.radiusHitsScreenTo){
          zoom = zoom - IntConfig.zoomChange;
        }
        if(radius > IntConfig.radiusHitsAgainScreenFrom && radius < IntConfig.radiusHitsAgainScreenTo) {
          zoom = zoom - IntConfig.zoomChange;
        }
      });
    }else{
      return CustomFlushBar(
        customContext: context,
        iconName: IconConfig.speaker,
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
        zoom = zoom + 0.05;
      });
    }else{
      return CustomFlushBar(
        customContext: context,
        iconName: IconConfig.speaker,
        text: CustomText(
          text: 'This is the minimum service area',
        ),
        message: 'This is the minimum service area',
      ).showFlushBar();
    }


  }
}
