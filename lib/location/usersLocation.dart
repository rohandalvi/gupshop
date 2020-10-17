import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/retriveFromFirebase/getUsersLocation.dart';


class UsersLocation{
  setUsersLocationToFirebase() async{
    var userPhoneNo = await UserDetails().getUserPhoneNoFuture();//get user phone no
    var ifHomeExists;
    await CollectionPaths.usersLocationCollectionPath.document(userPhoneNo)
        .setData({}, merge: true);

    ///if home location is not set then go on with setting the location
    var homeAddress = await GetUsersLocation(userPhoneNo: userPhoneNo)
        .getHomeAddress();

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

    LocationService().pushUsersLocationToFirebase(latitude,
        longitude, userPhoneNo, TextConfig.usersLocationCollectionHome, address); //pass a name for the location also as a parameter
  }

  Future<int> getNumberOfAddress(String userPhoneNo) async{
    DocumentSnapshot dc = await CollectionPaths.usersLocationCollectionPath
        .document(userPhoneNo).get();

    return dc.data.length;
  }

  createSetOfAddresses(String userPhoneNo) async{
    DocumentSnapshot dc = await CollectionPaths.usersLocationCollectionPath
        .document(userPhoneNo).get();

    Map dcMap = dc.data;
    Map map =  new HashMap();

    dcMap.forEach((addressName, data) {
      List<String> geoHashList = data[TextConfig.usersLocationCollectionGeoHashList].cast<String>();///type 'List<dynamic>' is not a subtype of type 'List<String>'
      String address = data[TextConfig.usersLocationCollectionAddress];

      /// adding both address and addressName to subMap
      /// Because, some methods need name and some need address
      Map subMap = new HashMap();
      subMap[TextConfig.usersLocationCollectionAddress] = address;
      subMap[TextConfig.changeLocationInSearchAddressName] = addressName;
      map[geoHashList] = subMap;
    });

    return map;
  }

  createSetOfAddressesTwo(String userPhoneNo) async{
    DocumentSnapshot dc = await CollectionPaths.usersLocationCollectionPath
        .document(userPhoneNo).get();

    Map dcMap = dc.data;
    Map map =  new HashMap();

    dcMap.forEach((addressName, data) {
      GeoPoint geoPoint = data[TextConfig.usersLocationCollectionGeoPoint];

      print("data TextConfig.usersLocationCollectionGeoHashList : ${data}");

      //List<String> geoHashList = data[TextConfig.usersLocationCollectionGeoHashList].cast<String>();///type 'List<dynamic>' is not a subtype of type 'List<String>'
      String address = data[TextConfig.usersLocationCollectionAddress];

      /// adding both address and addressName to subMap
      /// Because, some methods need name and some need address
      Map subMap = new HashMap();
      subMap[TextConfig.usersLocationCollectionAddress] = address;
      subMap[TextConfig.changeLocationInSearchAddressName] = addressName;
      String coordinates = LocationService().getCoordinates(latitude: geoPoint.latitude, longitude:geoPoint.longitude);

      map[coordinates] = subMap;
    });
    return map;
  }
  
  checkIfAddressExists(String userPhoneNo, double latitude, double longitude ) async{
  /// get a map of addresses in database in usersLocation
  Map map = await createSetOfAddressesTwo(userPhoneNo);

  /// check if the current location's coordinates is present in the map, if yes then
  /// dont add it, else add it
  String coordinates = LocationService().getCoordinates(latitude: latitude,
      longitude:longitude);

  if(map.containsKey(coordinates)) return map[coordinates]
  [TextConfig.changeLocationInSearchAddressName];
  return false;
  }


  getAddress(String userPhoneNo, List<String> userHash) async{
    Map map = await createSetOfAddresses(userPhoneNo);
    return map[userHash][TextConfig.usersLocationCollectionAddress];
  }




}