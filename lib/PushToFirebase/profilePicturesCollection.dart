import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';


class ProfilePicturesCollection{
  String userPhoneNo;

  ProfilePicturesCollection({this.userPhoneNo});

  DocumentReference path(){
    DocumentReference dc = CollectionPaths.profilePicturesChatsCollectionPath.document(userPhoneNo);
    return dc;
  }


  setPicture(String url){
    DocumentReference dc = path();
    return dc.setData({'url' : url});
  }
}