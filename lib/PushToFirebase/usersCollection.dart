import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';

class UsersCollection{
  String userPhoneNo;

  UsersCollection({this.userPhoneNo});

  DocumentReference path(){
    DocumentReference dc = CollectionPaths.usersCollectionPath.document(userPhoneNo);
    return dc;
  }

  setName({String userName}){
    DocumentReference dc = path();
    return dc.setData({'name':userName});
  }
}