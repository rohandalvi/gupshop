import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePictures{
  String userPhoneNo;

  ProfilePictures({this.userPhoneNo});

  getStream(){
    return Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots();
  }
}