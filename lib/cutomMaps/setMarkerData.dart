import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetMarkerData{
  final LatLng point;
  Set<Marker> markerSet;
  int markerIdCounter;

  SetMarkerData({this.point,this.markerSet,this.markerIdCounter});

  main(){
    print("markerIdCounter : $markerIdCounter");
    String markerId = 'marker_id_$markerIdCounter';
    markerIdCounter++;

    markerSet.add(
        Marker(
          markerId : MarkerId(markerId),
          position: point,
        )
    );

    return markerSet;
  }

}