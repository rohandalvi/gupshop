import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarTrace.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/navigators/navigateToCustomMap.dart';
import 'package:gupshop/location/usersLocation.dart';
import 'package:gupshop/responsive/textConfig.dart';

class ChangeLocationInSearch{
  String userNumber;
  String placeholder;
  bool showBackButton;

  ChangeLocationInSearch({this.userNumber, this.placeholder,this.showBackButton});

  Future<Map<String, dynamic>> getNewUserGeohash(BuildContext context) async{
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

    Map<String, dynamic> map = new Map();
    map[TextConfig.changeLocationInSearchAddressName] = addressName;

    List userGeohash = await LocationService().getUserGeohash(userNumber, addressName);
    print("userGeoohash in changeLocationInSearch : $userGeohash");
    map[TextConfig.geoHashList] = userGeohash;

//    List<String> userGeohash = await LocationService().getUserGeohash(userNumber, addressName);
//    map[TextConfig.usersLocationCollectionGeoHashList] = userGeohash;

    return map;
  }



  getUserGeoHashWithNewLatLng(){

  }


  getLatLang(BuildContext context) async{
    print("in getLatLang");

    GeoPoint location = await LocationService().getHomeLocation(number: userNumber);

    List latLangList = await NavigateToCustomMap(
      latitude: location.latitude,
      longitude: location.longitude,
      showRadius: false,
      placeholder: placeholder,
      showBackButton: showBackButton,
    ).navigateNoBrackets(context);

    return latLangList[0];
  }

  getAddress(Position location) async{
    String address = await LocationService().getAddress(location);
    return address;
  }

  pushToUsersLocationFirebase(double latitude, double longitude, String userPhoneNo,  String address, String addressName){
    LocationService().pushUsersLocationToFirebase(latitude, longitude, userPhoneNo, addressName, address);

    /// Trace
    LatLng location = new LatLng(latitude, longitude);
    BazaarTrace().locationAdded(location);
  }

//  getUserGeohash(String userPhoneNo, String addressName) async{
//    List<String> userGeohash = await LocationService().getUserGeohash(userPhoneNo, addressName);
//    return userGeohash;
//  }

  getGeoPoint(double latitude, double longitude){
    return LocationService().getGeoPoint(latitude, longitude);
  }
}