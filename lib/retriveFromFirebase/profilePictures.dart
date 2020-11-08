import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/PushToFirebase/profilePicturesCollection.dart';
import 'package:gupshop/image/imageTrace.dart';
import 'package:gupshop/responsive/textConfig.dart';

class ProfilePictures{
  String userPhoneNo;

  ProfilePictures({this.userPhoneNo});

  DocumentReference path(){
    return ProfilePicturesCollection(userPhoneNo: userPhoneNo).path();
  }

  getStream(){
    /// Trace
    ImageTrace(friendNumber: userPhoneNo).profilePictureView();

    return Firestore.instance.collection("profilePictures").document(userPhoneNo).snapshots();
  }

  Future<String> getProfilePicture() async{
    DocumentReference dr = path();
    DocumentSnapshot dc = await dr.get();
    String imageURL = dc.data[TextConfig.url];
    return imageURL;
  }
}