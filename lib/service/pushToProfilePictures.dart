import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/imageConfig.dart';

class PushToProfilePictures{

  newGroupProfilePicture(String userPhoneNo){
    String url = ImageConfig.groupDpPlaceholderStorageImage;
    Firestore.instance.collection("profilePictures").document(userPhoneNo).setData({'url' : url});
  }

}