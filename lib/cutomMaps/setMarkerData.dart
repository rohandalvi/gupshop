import 'dart:collection';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetMarkerData{
  final LatLng point;
  int markerIdCounter;

  SetMarkerData({this.point, this.markerIdCounter});

  main(){
    String markerId = 'marker_id_$markerIdCounter';
    markerIdCounter++;

    Set<Marker> markerSet = HashSet();
    markerSet.add(
        Marker(
          markerId : MarkerId(markerId),
          position: point,
        )
    );

    return markerSet;
  }

}