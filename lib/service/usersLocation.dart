import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gupshop/location/location_service.dart';

import 'getSharedPreferences.dart';

class UsersLocation{
  setUsersLocationToFirebase() async{
    var userPhoneNo = await GetSharedPreferences().getUserPhoneNoFuture();//get user phone no
    var ifHomeExists;
    await Firestore.instance.collection("usersLocation").document(userPhoneNo).setData({}, merge: true);

    ///if home location is not set then go on with setting the location
    var future = await Firestore.instance.collection("usersLocation").document(userPhoneNo).get();

    if(future.data["home"] == null){
      ifHomeExists= false;
    } else ifHomeExists = true;


    if(ifHomeExists == false) {
      Position location = await LocationService().getLocation();
      var latitude = location.latitude;
      var longitude = location.longitude;

      var address = await LocationService().getAddress();

      LocationService().pushUsersLocationToFirebase(latitude, longitude, userPhoneNo, "home", address); //pass a name for the location also as a parameter

      print("location set");
    }

  }
}