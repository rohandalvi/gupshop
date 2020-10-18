import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/PushToFirebase/pushToUsersLocationCollection.dart';
import 'package:gupshop/location/locationTrace.dart';
import 'package:gupshop/responsive/textConfig.dart';

class UpdateUsersLocation{
  String userPhoneNo;
  
  UpdateUsersLocation({this.userPhoneNo});


  DocumentReference path(String userNumber){
    DocumentReference dc = PushToUsersLocationCollection().path(userNumber);
    return dc;
  }
  
  updateHomeAddress(String address, var geoPoint, String geohash ) async{
    var addressMap = {
      TextConfig.usersLocationCollectionHome : {
        TextConfig.usersLocationCollectionAddress : address,
        TextConfig.usersLocationCollectionGeoPoint : geoPoint,
        TextConfig.usersLocationCollectionGeohash : geohash,
      }
    };

    await path(userPhoneNo).updateData(addressMap);

//    await Firestore.instance.collection("usersLocation")
//        .document(userPhoneNo).updateData(addressMap);

    LocationTrace().addressUpdatedByUser();
  }


}