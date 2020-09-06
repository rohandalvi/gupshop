import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/retriveFromFirebase/getUsersLocation.dart';

import '../service/getSharedPreferences.dart';

class UsersLocation{
  setUsersLocationToFirebase() async{
    var userPhoneNo = await GetSharedPreferences().getUserPhoneNoFuture();//get user phone no
    var ifHomeExists;
    await Firestore.instance.collection("usersLocation").document(userPhoneNo).setData({}, merge: true);

    ///if home location is not set then go on with setting the location
    var homeAddress = await GetUsersLocation(userPhoneNo: userPhoneNo).getHomeAddress();

    if(homeAddress == null){
      ifHomeExists= false;
    } else ifHomeExists = true;


    if(ifHomeExists == false) {
      pushUsersLocationToFirebase(userPhoneNo);
      print("location set");
    }

  }


  pushUsersLocationToFirebase(String userPhoneNo) async{
    Position location = await LocationService().getLocation();
    var latitude = location.latitude;
    var longitude = location.longitude;

    var address = await LocationService().getAddress(location);

    LocationService().pushUsersLocationToFirebase(latitude, longitude, userPhoneNo, "home", address); //pass a name for the location also as a parameter
  }

  Future<int> getNumberOfAddress(String userPhoneNo) async{
    DocumentSnapshot dc = await Firestore.instance.collection("usersLocation")
        .document(userPhoneNo).get();

    return dc.data.length;
  }

  createSetOfAddresses(String userPhoneNo) async{
    DocumentSnapshot dc = await Firestore.instance.collection("usersLocation")
        .document(userPhoneNo).get();

    Map dcMap = dc.data;
    Map map =  new HashMap();

    dcMap.forEach((addressName, data) {
      String geohash = data["geohash"];
      map[geohash] = addressName;
    });

    return map;
  }
  
  checkIfAddressExists(String userPhoneNo, double latitude, double longitude ) async{
    Geoflutterfire geo = Geoflutterfire();
    GeoFirePoint myLocation = geo.point(latitude: latitude, longitude: longitude);
    //var geoPoint = myLocation.geoPoint;
    String geohash = myLocation.hash;

    Map map = await createSetOfAddresses(userPhoneNo);
    print("map in checkIfAddressExists : $map");
    
    if(map.containsKey(geohash)) return map[geohash];
    return false;
  }


  getAddressName(String userPhoneNo, String userHash) async{
    Map map = await createSetOfAddresses(userPhoneNo);

    return map[userHash];
  }


}