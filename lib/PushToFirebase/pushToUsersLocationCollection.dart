import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';

class PushToUsersLocationCollection{

  DocumentReference path(String userNumber){
    DocumentReference dc = CollectionPaths.usersLocationCollectionPath.document(userNumber);
    return dc;
  }

  pushUsersLocationToFirebase({String userNumber, String locationName, var dataMap}){
    return path(userNumber).setData({locationName: dataMap}, merge:true);//merge true imp for setting multiple locations
  }
}