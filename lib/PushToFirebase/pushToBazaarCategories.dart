import 'package:cloud_firestore/cloud_firestore.dart';

class PushToBazaarCategories{

  addUser(String category, String subCategory, String userName, String userPhoneNo){
    Firestore.instance.collection("bazaarCategories").document(category).setData({}, merge: true);///creating document to avoid error document(i

    var result = {
      userPhoneNo: {
        'name': userName
      }
    };
    Firestore.instance.collection("bazaarCategories").document(category)
    .collection("subCategories").document(subCategory).setData(result,merge: true);
  }

}