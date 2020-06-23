import 'package:cloud_firestore/cloud_firestore.dart';

class PushToProfilePictures{

  newGroupProfilePicture(String userPhoneNo){
    String url = "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/groupManWoman.png?alt=media&token=642a70fb-f47f-4f66-ba36-134a2e629b47";
    Firestore.instance.collection("profilePictures").document(userPhoneNo).setData({'url' : url});
  }

}