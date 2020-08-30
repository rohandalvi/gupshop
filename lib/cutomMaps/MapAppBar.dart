import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/responsive/keys.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:search_map_place/search_map_place.dart';

class MapAppBar extends StatefulWidget {
  final LatLng location;
  final void Function(Place place) onSelected;


  MapAppBar({this.location, this.onSelected});

  @override
  _MapAppBarState createState() => _MapAppBarState();
}

class _MapAppBarState extends State<MapAppBar> {
  SearchMapPlaceWidget result;

  @override
  void dispose() {
    print("in mapAppBar dispose");
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new  SearchMapPlaceWidget(
        apiKey: Keys().mapAPI,
        language: 'en',
        location: widget.location,
        onSelected: widget.onSelected,
      ),
    );

  }
}
