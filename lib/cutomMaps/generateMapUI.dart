import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/cutomMaps/mapUI.dart';
import 'package:gupshop/cutomMaps/setCircleData.dart';
import 'package:gupshop/cutomMaps/setMarkerData.dart';
import 'package:gupshop/responsive/intConfig.dart';

class GenerateMapUI extends StatefulWidget {
  double latitude;
  double longitude;

  Set<Marker> markerSet;
  int markerIdCounter;

  Set<Circle> circleSet;
  bool showRadius;
  double radius;
  int circleIdCounter;
  double zoom;

  GenerateMapUI({this.longitude, this.latitude, this.circleSet, this.markerSet,
    this.showRadius, this.radius, this.circleIdCounter,
    this.markerIdCounter,this.zoom

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
  double radius = IntConfig.radius;

  int circleIdCounter = 1;


  @override
  void initState() {
    setMarkers();
    super.initState();
  }

 @override
  void didUpdateWidget(GenerateMapUI oldWidget) {
    setMarkers();

    print("zoom in didUpdateWidget : ${widget.zoom}");
    /// this is required:
    mapController.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(widget.latitude, widget.longitude,),
      zoom: widget.zoom,
//      zoom: zoom
      //zoom: IntConfig.zoom,
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
      zoom: widget.zoom,
      //zoom: zoom,
    );
  }


  /// markers - circle and marker point
  setMarkers(){
    LatLng point = new LatLng(widget.latitude, widget.longitude);
    resetSetCircle(point);
  }

  resetSetCircle(LatLng point){
    print("widget.zoom : ${widget.zoom}");
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
//      zoom = zoom - 0.1;
    });

  }


  onMapCreated(controller){
    setState(() {
      mapController = controller;
    });
  }

}
