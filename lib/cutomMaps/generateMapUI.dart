import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/cutomMaps/mapUI.dart';
import 'package:gupshop/cutomMaps/setCircleData.dart';
import 'package:gupshop/cutomMaps/setMarkerData.dart';

class GenerateMapUI extends StatefulWidget {
  final double latitude;
  final double longitude;

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

  @override
  void initState() {
    print("in GenerateMapUI initState");

    /// for 1st time map :
    LatLng point = new LatLng(widget.latitude, widget.longitude);

    if(widget.showRadius == true){
      widget.circleSet = SetCircleData(
        point: point,
        circleSet: widget.circleSet,
        radius: widget.radius,
        circleIdCounter: widget.circleIdCounter,
      ).main();

      widget.markerSet = SetMarkerData(
          point: point,
          markerIdCounter: widget.markerIdCounter,
          markerSet: widget.markerSet
      ).main();
    }else{
      widget.markerSet = SetMarkerData(
          point: point,
          markerIdCounter: widget.markerIdCounter,
          markerSet: widget.markerSet
      ).main();
    }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Lat : ${widget.latitude}");
    print("Lang : ${widget.longitude}");
    print("marker : ${widget.markerSet}");
    print("circle : ${widget.circleSet.elementAt(0).circleId}");
    return MapUI(
      latitude: widget.latitude,
      longitude: widget.longitude,
      markerSet: widget.markerSet,
      circleSet: widget.circleSet,
      zoom: 15,
//      onTap: (point) async{
//        if(widget.showRadius == true){
//          Set<Circle> tempCircleSet = await SetCircleData(
//            point: point,
//            circleSet: widget.circleSet,
//            radius: widget.radius,
//            circleIdCounter: widget.circleIdCounter,
//          ).main();
//
//          Set<Marker> tempMarkerSet = await SetMarkerData(
//            point: point,
//            markerIdCounter: widget.markerIdCounter,
//            markerSet: widget.markerSet
//          ).main();
//
//          setState(() {
//            widget.circleSet = tempCircleSet;
//            widget.markerSet = tempMarkerSet;
//          });
//
//        }else {
//          Set<Marker> tempMarkerSet = await SetMarkerData(
//              point: point,
//              markerIdCounter: widget.markerIdCounter,
//              markerSet: widget.markerSet
//          ).main();
//          setState(() {
//            widget.markerSet = tempMarkerSet;
//          });
//        }
//      },
    );
  }
}
