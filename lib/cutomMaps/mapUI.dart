import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUI extends StatelessWidget {
  final double latitude;
  final double longitude;
  final ArgumentCallback<LatLng> onTap;
  final double zoom;
  final bool mapToolbarEnabled;
  final MapCreatedCallback onMapCreated;

  Set<Marker> markerSet;
  Set<Circle> circleSet;

  MapUI({this.latitude, this.longitude, this.circleSet, this.markerSet, this.onTap,
    this.zoom, this.mapToolbarEnabled, this.onMapCreated});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(latitude,longitude),
        zoom: zoom,
      ),
      markers: markerSet,
      circles: circleSet,
      myLocationEnabled: true,
      onTap: onTap,
      mapType: MapType.normal,
      mapToolbarEnabled: mapToolbarEnabled,

      /// for removing the compass like looking button, which is placed at the
      /// top right corner of the screen
      myLocationButtonEnabled: false,
    );
  }


}
