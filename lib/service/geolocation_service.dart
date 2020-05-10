
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart' as gc;
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
//import 'package:location/location.dart';

class GeolocationService extends StatefulWidget {
  @override
  GeolocationServiceState createState() => GeolocationServiceState();
}

class  C {
  Stream<DocumentSnapshot> s1;
  Stream<DocumentSnapshot> s2;

  C({@required s1, @required s2});
}

class GeolocationServiceState extends State<GeolocationService> {

  Position _location;
  double latitude;
  double longitude;
  double distance = 50;

  String category ="kamwali";

  String _userGeohash;
  String _bazaarWalaUpperGeoHash;
  String _bazaarWalaLowerGeoHash;

  Query _query;




  static const double LATITUDE = 0.0144927536231884; // degrees latitude per mile
  static const LONGITUDE = 0.0181818181818182; // degrees longitude per mile


  Geoflutterfire geo = Geoflutterfire();


  _getLatitudeLongitude(Position _location){
    setState(() {
      latitude = _location.latitude;
      longitude = _location.longitude;
    });

//    latitude = _location.latitude;
//    longitude = _location.longitude;
    print("lati:${latitude}, longi:${longitude}");
    //Firestore.instance.collection("bazaarWalasLocation").document("+919870725050").setData({"latitude": latitude},merge: true);//this would be used the bazaarwala gives his location during the making of his profile
    //for the user, this data will be pushed when the user visits bazaar page for the first time
  }



  //2
  pushBazaarWalasLocationToFirebase(double latitude, double longitude){//used in createBazaarwala profile page
    String phoneNo = "+919870725050";
    print("geo : $geo");
    print("latitude :$latitude");
    print("mylocation: ${geo.point(latitude: latitude, longitude: longitude)}");

    GeoFirePoint myLocation = geo.point(latitude: latitude, longitude: longitude);
    print("mylocation.data: ${myLocation.data}");

    String bazaarWalasUpperRadius = _getBazaarWalasUpperRadius(latitude, longitude, distance);//distance 50//static for now//later can be asked from the bazaarwalas
    String bazaarWalasLowerRadius = _getBazaarWalasLowerRadius(latitude, longitude, distance);

    print("My location ${myLocation.hash} , radiusHash: $bazaarWalasLowerRadius result: ${myLocation.hash.compareTo(bazaarWalasLowerRadius)}");
    print("My location ${myLocation.hash} , radiusHash: $bazaarWalasUpperRadius result: ${myLocation.hash.compareTo(bazaarWalasUpperRadius)}");

    var position =
    {
      'geoHash': myLocation.hash,
      'geoPoint': myLocation.geoPoint,
      'upperGeoHash':bazaarWalasUpperRadius,
      'lowerGeoHash': bazaarWalasLowerRadius,
    };


    Firestore.instance.collection("bazaarWalasLocation").document("kamwali").collection("kamwali").document(phoneNo).setData(position);

    //Firestore.instance.collection("bazaarWalasLocation").document("+919029169619").setData(position);
    print("myLocation data: ${myLocation.data}");
  }


  //use in bazaarHome_screen to set the user's location to firebase
  pushUsersLocationToFirebase(var latitude, var longitude, String phoneNo, String locationName, var address){//set users location to firebase
    GeoFirePoint myLocation = geo.point(latitude: latitude, longitude: longitude);

    var map =
    {
      'geohash' : myLocation.hash,
      'geoPoint': myLocation.geoPoint,
      'address' : address,
    };

    //Firestore.instance.collection("usersLocation").document(phoneNo).setData({'position': myLocation.data});
    Firestore.instance.collection("usersLocation").document(phoneNo).setData({locationName: map}, merge:true);//merge true imp for setting multiple locations
    print("myLocation.data of user: ${myLocation.data}");
  }

  //4
  getGeopointAndGeohashObject(var latitude, var longitude){
    GeoFirePoint myLocation = geo.point(latitude: latitude, longitude: longitude);
    return myLocation;
  }

  Future<DocumentSnapshot> getBazaarWalaGeoHash(number, category) {
    return Firestore.instance.collection("bazaarWalasLocation").document(category).collection(number).document(number).get();
  }


   getUserLocation(number){//get location already stored in firebase
    print("getusergeohash madhe number : $number");
    Firestore.instance.collection("usersLocation").document(number).get().then((onVal){
      print("getUserLocationVal: ${onVal.data}");
    });
    return Firestore.instance.collection("usersLocation").document(number).get();
  }


  Future<Position> getLocation() async{// returns user's actual location using satellite
    Position location = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return location;
  }

  getAddress() async{// returns user's actual location using satellite
    Position location = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var latitude = location.latitude;
    var longitude = location.longitude;
    var coordinates = new gc.Coordinates(latitude, longitude);

    var addressList = await gc.Geocoder.local.findAddressesFromCoordinates(coordinates);
    var address = addressList[2].addressLine;

    print("address: ${address}");
    return address;
  }


  //helpers
  String _getBazaarWalasUpperRadius(double latitude, double longitude, double distance){
    double upperLat = latitude + LATITUDE * distance;
    double upperLong = longitude + LONGITUDE * distance;

    GeoFirePoint objectToGetGeoHash = geo.point(latitude: upperLat, longitude: upperLong);

    String geoHash = objectToGetGeoHash.hash;
    print("geoHash: ${geoHash}");

    return geoHash;
  }
  String _getBazaarWalasLowerRadius(double latitude, double longitude, double distance){
    double upperLat = latitude - LATITUDE * distance;
    double upperLong = longitude - LONGITUDE * distance;

    GeoFirePoint objectToGetGeoHash = geo.point(latitude: upperLat, longitude: upperLong);

    String geoHash = objectToGetGeoHash.hash;
    print("geoHash: ${geoHash}");

    return geoHash;
  }


  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    pushUsersLocationToFirebase(47.606209, -122.332069, "+19194134191");
  getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
    //  child: Text("latitude: ${_location.latitude}, longitude :${_location.longitude} "),
    );
  }
}


//guidance for storing futures  in an array:

/*
Future<DocumentSnapshot> s1 = getUserGeoHash(number);
Future<DocumentSnapshot> s2 = getBazaarWalaGeoHash("+919029169619", category);

    futures.add(s1);
    futures.add(s2);
    return await  Future.wait(futures).then((onValue) {
      String userGeohash =  onValue[0]["position"]["geohash"];
}
 */