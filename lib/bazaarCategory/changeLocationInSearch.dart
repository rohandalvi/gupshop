import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/navigators/navigateToCustomMap.dart';
import 'package:gupshop/usersLocation/usersLocation.dart';

class ChangeLocationInSearch{
  String userNumber;
  String placeholder;

  ChangeLocationInSearch({this.userNumber, this.placeholder});

  getNewUserGeohash(BuildContext context) async{
    /// get lat lang:
    LatLng location = await getLatLang(context);
    double latitude = location.latitude;
    double longitude =  location.longitude;

    /// creating address from lat lang:
    Position position = new Position(latitude: latitude, longitude: longitude);
    String address = await getAddress(position);

    /// creating a name for the address:
    /// 1st check if the address already exists in firebase
    /// checkIfAddressExists returns false if the address does not exist, else
    /// it returns the name of the address
    var addressExists = await UsersLocation().checkIfAddressExists(userNumber, latitude, longitude);
    String addressName;

    if(addressExists == false){
      int addressNumber = await UsersLocation().getNumberOfAddress(userNumber);
      addressName = "address${addressNumber++ }";
      /// pushing to firebase usersLocation collection:
      await pushToUsersLocationFirebase(latitude, longitude, userNumber, address, addressName);
    }else{
      addressName = addressExists;
    }

    String userGeohash = await LocationService().getUserGeohash(userNumber, addressName);
    return userGeohash;
  }


  getLatLang(BuildContext context) async{

    GeoPoint location = await LocationService().getHomeLocation(userNumber);

    List latLangList = await NavigateToCustomMap(
      latitude: location.latitude,
      longitude: location.longitude,
      showRadius: false,
      placeholder: placeholder
    ).navigateNoBrackets(context);

    return latLangList[0];
  }

  getAddress(Position location) async{
    String address = await LocationService().getAddress(location);
    return address;
  }

  pushToUsersLocationFirebase(double latitude, double longitude, String userPhoneNo,  String address, String addressName){
    LocationService().pushUsersLocationToFirebase(latitude, longitude, userPhoneNo, addressName, address);
  }

  getUserGeohash(String userPhoneNo, String addressName){
    String userGeohash = LocationService().getUserGeohash(userPhoneNo, addressName);
    return userGeohash;
  }

  getGeoPoint(double latitude, double longitude){
    return LocationService().getGeoPoint(latitude, longitude);
  }
}