import 'dart:collection';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/colors/colorPalette.dart';

class SetCircleData{
  final LatLng point;

  double radius;
  int circleIdCounter;

  SetCircleData({this.point,this.radius, this.circleIdCounter});

  main(){
    String circleId = 'circle_id_$circleIdCounter';
    circleIdCounter++;

    Set<Circle> circleSet = HashSet();
    circleSet.add(
      Circle(
        circleId: CircleId(circleId),
        center: point,
        radius: radius,
        fillColor: customMapCircle.withOpacity(0.5),
        strokeWidth: 2,
        strokeColor: customMapCircle
      )
    );

    return circleSet;
  }

}