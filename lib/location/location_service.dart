
import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart' as gc;
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasLocation.dart';
import 'package:gupshop/PushToFirebase/pushToUsersLocationCollection.dart';
import 'package:gupshop/location/geoHash.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/intConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationService {
  double latitude;
  double longitude;

  /// take this as radius from  firebase
//  double distance = 50;


  static const double LATITUDE = 0.0144927536231884; /// degrees latitude per mile
  static const LONGITUDE = 0.0181818181818182; /// degrees longitude per mile


  Geoflutterfire geo = Geoflutterfire();

  GeoHash myGeoHash = new GeoHash();


  getLocationInOurFormat(double latitude, double longitude, double radius){
    GeoFirePoint myLocation = geo.point(latitude: latitude, longitude: longitude);

    String bazaarWalasUpperRadius = _getBazaarWalasUpperRadius(latitude, longitude, radius);//distance 50//static for now//later can be asked from the bazaarwalas
    String bazaarWalasLowerRadius = _getBazaarWalasLowerRadius(latitude, longitude, radius);

    var position =
    {
      'geoHash': myLocation.hash,
      'geoPoint': myLocation.geoPoint,
      'upperGeoHash':bazaarWalasUpperRadius,
      'lowerGeoHash': bazaarWalasLowerRadius,
      'radius' : radius,
    };

    return position;
  }

  /// see if the radius for bazaarwalas is showing correct results in individual dispaly
//  pushBazaarWalasLocationToFirebase(double latitude, double longitude, String categoryName,String userNumber, String subCategory, double radius){//used in createBazaarwala profile page
//    var position = getLocationInOurFormat(latitude, longitude, radius);
//
//    /// ToDo : use from pushToFirebase package instead:
//    PushToBazaarWalasLocation(
//      position: position, userNumber: userNumber, category: categoryName, subCategory:subCategory,
//      latitude: latitude, longitude: longitude
//    ).push();
//  }


//  ///use in bazaarHome_screen to set the user's location to firebase
//  pushUsersLocationToFirebase(var latitude, var longitude, String phoneNo, String locationName, var address){//set users location to firebase
//    GeoFirePoint myLocation = geo.point(latitude: latitude, longitude: longitude);
//
//    var map =
//    {
//      'geohash' : myLocation.hash,
//      'geoPoint': myLocation.geoPoint,
//      'address' : address,
//    };
//
//    //Firestore.instance.collection("usersLocation").document(phoneNo).setData({'position': myLocation.data});
//    CollectionPaths.usersLocationCollectionPath.document(phoneNo).setData({locationName: map}, merge:true);//merge true imp for setting multiple locations
//  }

  getGeoPoint(double latitude, double longitude,){
    GeoFirePoint myLocation = geo.point(latitude: latitude, longitude: longitude);
    return myLocation.geoPoint;
  }

  //4
  getGeopointAndGeohashObject(double latitude, double longitude){
    GeoFirePoint myLocation = geo.point(latitude: latitude, longitude: longitude);
    return myLocation;
  }

  Future<DocumentSnapshot> getBazaarWalaGeoHash(number, category) {
    return Firestore.instance.collection("bazaarWalasLocation").document(category).collection(number).document(number).get();
  }


   getUserLocationDocumentSnapshot(number) async{//get location already stored in firebase
//    Firestore.instance.collection("usersLocation").document(number).get().then((onVal){
//    });
   print("getUserLocationDocumentSnapshot : ${await CollectionPaths.usersLocationCollectionPath.document(number).get()}");
    return await CollectionPaths.usersLocationCollectionPath.document(number).get();
  }

  getHomeLocation(number) async{
    DocumentSnapshot dc = await getUserLocationDocumentSnapshot(number);
    GeoPoint latLng =  dc.data["home"]["geoPoint"];
    return latLng;

  }


  Future<Position> getLocation() async{// returns user's actual location using satellite
    Position location = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return location;
  }

  ///an example of async await function:
  getAddress(Position location) async{// returns user's actual location using satellite
    //Position location = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var latitude = location.latitude;
    var longitude = location.longitude;
//    var coordinates = new gc.Coordinates(latitude, longitude);
//
//    var addressList = await gc.Geocoder.local.findAddressesFromCoordinates(coordinates);
    var address = await getAddressFromLatLang(latitude, longitude);

    print("address in locationService : $address");
    return address;
  }

  getAddressFromLatLang(double latitude,  double longitude) async{
    var coordinates = new gc.Coordinates(latitude, longitude);
    var addressList = await gc.Geocoder.local.findAddressesFromCoordinates(coordinates);
    print("addressList in getAddressFromLatLang : $addressList");
    print("addressList-0 in getAddressFromLatLang : ${addressList[0].addressLine}");
    print("addressList-1 in getAddressFromLatLang : ${addressList[1]}");
    print("addressList-2 in getAddressFromLatLang : ${addressList[2]}");
    var address = addressList[2].addressLine;
    print("address in getAddressFromLatLang : $address");
    return address;
  }


  /// geohash change here
  //helpers
  String _getBazaarWalasUpperRadius(double latitude, double longitude, double distance){
    double upperLat = latitude + LATITUDE * distance;
    double upperLong = longitude + LONGITUDE * distance;

    GeoFirePoint objectToGetGeoHash = geo.point(latitude: upperLat, longitude: upperLong);

    String geoHash = objectToGetGeoHash.hash;

    return geoHash;
  }


  /// geohash change here
  String _getBazaarWalasLowerRadius(double latitude, double longitude, double distance){
    double upperLat = latitude - LATITUDE * distance;
    double upperLong = longitude - LONGITUDE * distance;

    GeoFirePoint objectToGetGeoHash = geo.point(latitude: upperLat, longitude: upperLong);

    String geoHash = objectToGetGeoHash.hash;

    return geoHash;
  }

  void launchMapsUrl(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  showLocation(String senderName,double latitude, double longitude){
    return CustomRaisedButton(
      child: CustomText(text: '$senderName \nCurrent Location 📍',),/// toDo- very very big name
//      shape:  RoundedRectangleBorder(
//        borderRadius: new BorderRadius.circular(5.0),
//        side: BorderSide(color : Colors.black),
//      ),
      onPressed: (){
        LocationService().launchMapsUrl(latitude, longitude);
      },
    );
  }

  showAddress(String addressName){
    return CustomText(text: addressName,textAlign: TextAlign.center,).hyperLink();
  }

  showLocationElevated(String senderName,double latitude, double longitude){
    return CustomRaisedButton(
      child: CustomText(text: '$senderName \nCurrent Location 📍',),/// toDo- very very big name
      onPressed: (){
        LocationService().launchMapsUrl(latitude, longitude);
      },
    ).elevated();
  }

  Future<List<String>> getUserGeohash(String number, String addressName) async{
    DocumentSnapshot dc = await LocationService().getUserLocationDocumentSnapshot(number);
    List<String> result =  dc.data[addressName][TextConfig.usersLocationCollectionGeoHashList].cast<String>();
    return result;
  }

  createGeohash(double latitude, double longitude) async{
    GeoFirePoint myLocation = await  getGeopointAndGeohashObject(latitude, longitude);
    return myLocation.hash;
  }


  pushBazaarWalasLocationToFirebase(double latitude, double longitude, String categoryName,String userNumber, String subCategory, double radius){//used in createBazaarwala profile page
    /// generate a list of geoHashes(using proximity_hash library)
    /// get lat and lang
    /// get radius
    /// push all 3 in bazaarwalaLocation collection

    /// list of geohash:
    List<String> geoHashList = myGeoHash.getListOfGeoHash(radius: radius, longitude: longitude, latitude: latitude);

    GeoFirePoint myLocation = geo.point(latitude: latitude, longitude: longitude);

    print("geoHashList in pushBazaarWalasLocationToFirebase : $geoHashList");


    /// get lat and lang
    /// get radius
    var position =
    {
      'geoHashList': geoHashList,
      'geoPoint': myLocation.geoPoint,
      'radius' : radius,
    };


    /// push all 3 in bazaarwalaLocation collection
    /// ToDo : use from pushToFirebase package instead:
    /// use same method below, just change the var position
    PushToBazaarWalasLocation(
        position: position, userNumber: userNumber, category: categoryName, subCategory:subCategory,
        latitude: latitude, longitude: longitude
    ).push();
  }


  ///use in bazaarHome_screen to set the user's location to firebase
  pushUsersLocationToFirebase(var latitude, var longitude, String userNumber, String locationName, var address){//set users location to firebase
    GeoFirePoint myLocation = geo.point(latitude: latitude, longitude: longitude);

    /// create a list of geoHash to be set in userLocation collection
    List<String> userGeoHashList = myGeoHash.getListOfGeoHash(latitude: latitude, longitude: longitude, radius: IntConfig.radiusForUsers);/// radiusForUsers = 1


    var map =
    {
      'geoHashList' : userGeoHashList,
      'geoPoint': myLocation.geoPoint,
      'address' : address,
    };

    //Firestore.instance.collection("usersLocation").document(phoneNo).setData({'position': myLocation.data});
    //CollectionPaths.usersLocationCollectionPath.document(phoneNo).setData({locationName: map}, merge:true);//merge true imp for setting multiple locations
    PushToUsersLocationCollection().pushUsersLocationToFirebase(userNumber:userNumber, locationName: locationName, dataMap: map );
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