
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart' as gc;
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasLocation.dart';
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

//  LocationService({this.distance});

  Geoflutterfire geo = Geoflutterfire();


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

  //2
  pushBazaarWalasLocationToFirebase(double latitude, double longitude, String categoryName,String userNumber, String subCategory, double radius){//used in createBazaarwala profile page
    var position = getLocationInOurFormat(latitude, longitude, radius);

    /// use from pushToFirebase package instead:
    PushToBazaarWalasLocation(
      position: position, userNumber: userNumber, category: categoryName, subCategory:subCategory,
      latitude: latitude, longitude: longitude
    ).push();
//    Firestore.instance.collection("bazaarWalasLocation").document(categoryName).setData({}, merge: true);///creating document to avoid error document(italic) creation
//    Firestore.instance.collection("bazaarWalasLocation").document(categoryName).collection(categoryName).document(userNumber).setData(position);
  }


  ///use in bazaarHome_screen to set the user's location to firebase
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
    Firestore.instance.collection("usersLocation").document(number).get().then((onVal){
    });
    return Firestore.instance.collection("usersLocation").document(number).get();
  }


  Future<Position> getLocation() async{// returns user's actual location using satellite
    Position location = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return location;
  }

  ///an example of async await function:
  getAddress() async{// returns user's actual location using satellite
    Position location = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var latitude = location.latitude;
    var longitude = location.longitude;
    var coordinates = new gc.Coordinates(latitude, longitude);

    var addressList = await gc.Geocoder.local.findAddressesFromCoordinates(coordinates);
    var address = addressList[2].addressLine;

    return address;
  }


  //helpers
  String _getBazaarWalasUpperRadius(double latitude, double longitude, double distance){
    double upperLat = latitude + LATITUDE * distance;
    double upperLong = longitude + LONGITUDE * distance;

    GeoFirePoint objectToGetGeoHash = geo.point(latitude: upperLat, longitude: upperLong);

    String geoHash = objectToGetGeoHash.hash;

    return geoHash;
  }

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