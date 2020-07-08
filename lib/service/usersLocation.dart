import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gupshop/service/geolocation_service.dart';

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
    }ifHomeExists = true;


    if(ifHomeExists == false) {
      Position location = await GeolocationServiceState().getLocation();
      var latitude = location.latitude;
      var longitude = location.longitude;

      var address = await GeolocationServiceState().getAddress();

      GeolocationServiceState().pushUsersLocationToFirebase(latitude, longitude, userPhoneNo, "home", address); //pass a name for the location also as a parameter

      print("location set");
    }

  }
}