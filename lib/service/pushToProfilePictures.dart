import 'package:cloud_firestore/cloud_firestore.dart';

class PushToProfilePictures{

  newGroupProfilePicture(String userPhoneNo){
    String url = "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/user.png?alt=media&token=28bcfc15-31da-4847-8f7c-efdd60428714";
    Firestore.instance.collection("profilePictures").document(userPhoneNo).setData({'url' : url});
  }

}