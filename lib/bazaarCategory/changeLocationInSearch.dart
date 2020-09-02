import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/navigators/navigateToCustomMap.dart';
import 'package:gupshop/usersLocation/usersLocation.dart';
import 'package:gupshop/widgets/customDialogForConfirmation.dart';

class ChangeLocationInSearch{
  String userNumber;

  ChangeLocationInSearch({this.userNumber});

  getNewUserGeohash(BuildContext context) async{
    /// get lat lang:
    LatLng location = await getLatLang(context);
    double latitude = location.latitude;
    double longitude =  location.longitude;

    /// creating address from lat lang:
    Position position = new Position(latitude: latitude, longitude: longitude);
    String address = getAddress(position);

    /// creating a name for the address:
    int addressNumber = await UsersLocation().getNumberOfAddress(userNumber);
    String addressName = "address${addressNumber++ }";

    /// pushing to firebase usersLocation collection:
    pushToUsersLocationFirebase(latitude, longitude, userNumber, address, addressName);

    String userGeohash = await LocationService().getUserGeohash(userNumber, addressName);
    return userGeohash;
  }

  getLatLang(BuildContext context) async{

    GeoPoint location = await LocationService().getHomeLocation(userNumber);

    List latLangList = await NavigateToCustomMap(
      latitude: location.latitude,
      longitude: location.longitude,
      showRadius: false,
    ).navigateNoBrackets(context);

    return latLangList[0];
  }

  getAddress(Position location) async{
    String address = await LocationService().getAddress(location);
  }

  pushToUsersLocationFirebase(double latitude, double longitude, String userPhoneNo,  String address, String addressName){
    LocationService().pushUsersLocationToFirebase(latitude, longitude, userPhoneNo, addressName, address);
  }

  getUserGeohash(String userPhoneNo, String addressName){
    String userGeohash = LocationService().getUserGeohash(userPhoneNo, addressName);
    return userGeohash;
  }
}