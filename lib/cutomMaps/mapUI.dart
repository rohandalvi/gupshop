import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUI extends StatelessWidget {
  final double latitude;
  final double longitude;
  final ArgumentCallback<LatLng> onTap;
  final double zoom;

  Set<Marker> markerSet;
  Set<Circle> circleSet;

  MapUI({this.latitude, this.longitude, this.circleSet, this.markerSet, this.onTap, this.zoom});

  @override
  Widget build(BuildContext context) {
    print("Lat in MapUI: ${latitude}");
    print("Lang in MapUI: ${longitude}");
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(latitude,longitude),
        zoom: zoom,
      ),
      markers: markerSet,
      circles: circleSet,
      myLocationEnabled: true,
      onTap: onTap,
      mapType: MapType.normal,
    );
  }
}
