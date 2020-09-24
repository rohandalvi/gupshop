import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/image/imageTrace.dart';

class ProfilePictures{
  String userPhoneNo;

  ProfilePictures({this.userPhoneNo});

  getStream(){
    /// Trace
    ImageTrace(friendNumber: userPhoneNo).profilePictureView();

    return Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots();
  }
}