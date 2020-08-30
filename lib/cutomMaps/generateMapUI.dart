import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/cutomMaps/mapUI.dart';
import 'package:gupshop/cutomMaps/setCircleData.dart';
import 'package:gupshop/cutomMaps/setMarkerData.dart';

class GenerateMapUI extends StatefulWidget {
  double latitude;
  double longitude;

  Set<Marker> markerSet;
  int markerIdCounter;

  Set<Circle> circleSet;
  bool showRadius;
  double radius;
  int circleIdCounter;

  GenerateMapUI({this.longitude, this.latitude, this.circleSet, this.markerSet,
    this.showRadius, this.radius, this.circleIdCounter,
    this.markerIdCounter,

  });

  @override
  _GenerateMapUIState createState() => _GenerateMapUIState();
}

class _GenerateMapUIState extends State<GenerateMapUI> {

  GoogleMapController mapController;
  Set<Marker> markerSet = new HashSet();

  int markerIdCounter = 1;

  Set<Circle> circleSet = new HashSet();

  /// this would be flexible
  double radius = 300;

  int circleIdCounter = 1;


  @override
  void initState() {
    setMarkers();
    super.initState();
  }

 @override
  void didUpdateWidget(GenerateMapUI oldWidget) {
    setMarkers();

    /// this is required:
    mapController.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(widget.latitude, widget.longitude,),
      zoom: 15,
    )));


    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MapUI(
      latitude: widget.latitude,
      longitude: widget.longitude,
      markerSet: widget.markerSet,
      circleSet: widget.circleSet,
      onMapCreated: onMapCreated,
      zoom: 15,
    );
  }


  /// markers - circle and marker point
  setMarkers(){
    LatLng point = new LatLng(widget.latitude, widget.longitude);
    resetSetCircle(point);
  }

  resetSetCircle(LatLng point){
    setState(() {
      if(widget.showRadius == true){
        widget.circleSet = SetCircleData(
          point: point,
          radius: widget.radius,
          circleIdCounter: widget.circleIdCounter,
        ).main();

        widget.markerSet = SetMarkerData(
            point: point,
            markerIdCounter: widget.markerIdCounter
        ).main();
      }else{
        widget.markerSet = SetMarkerData(
            point: point,
            markerIdCounter: widget.markerIdCounter
        ).main();
      }
    });

  }


  onMapCreated(controller){
    setState(() {
      mapController = controller;
    });
  }

}
