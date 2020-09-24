import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/location/locationTrace.dart';
import 'package:gupshop/responsive/textConfig.dart';

class UpdateUsersLocation{
  String userPhoneNo;
  
  UpdateUsersLocation({this.userPhoneNo});
  
  updateHomeAddress(String address, var geoPoint, String geohash ) async{

    var addressMap = {
      'home' : {
        'address' : address,
        'geoPoint' : geoPoint,
        'geohash' : geohash,
      }
    };

    await Firestore.instance.collection("usersLocation")
        .document(userPhoneNo).updateData(addressMap);

    LocationTrace().addressUpdatedByUser();
  }


}