import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'mapsBloc.dart';
import 'mapsEvent.dart';

class LocationUser extends StatelessWidget {
  const LocationUser({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 85,
      right: 5,
      child: Card(
        child: IconButton(
          icon: Icon(
            Icons.gps_fixed,
            color: Colors.grey[700],
          ),
          onPressed: () {
            BlocProvider.of<MapsBloc>(context).add(GetUserLocationPressed());
          },
        ),
      ),
    );
  }
}