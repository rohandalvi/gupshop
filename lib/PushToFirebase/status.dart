import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';


class Status{
  String userPhoneNo;

  Status({this.userPhoneNo});

  DocumentReference path(){
    DocumentReference dc = CollectionPaths.statusCollectionPath.document(userPhoneNo);
    return dc;
  }


  setStatus(String status){
    DocumentReference dc = path();
    return dc.setData({'url' : status});
  }
}