import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePictures{
  String userPhoneNo;
  String categoryName;

  ProfilePictures({this.userPhoneNo, });

  stream(){
    return Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots();
  }
}