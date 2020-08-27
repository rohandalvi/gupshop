import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/responsive/keys.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:search_map_place/search_map_place.dart';

class MapAppBar extends StatelessWidget {
  final LatLng location;
  final void Function(Place place) onSelected;

  MapAppBar({this.location, this.onSelected});


  @override
  Widget build(BuildContext context) {
    return SearchMapPlaceWidget(
      apiKey: Keys().mapAPI,
      language: 'en',
      location: location,
      onSelected: onSelected,
    );
  }
}
