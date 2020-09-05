import 'package:cloud_firestore/cloud_firestore.dart';

class PushToCategoriesMatedata{
  String userNumber;

  PushToCategoriesMatedata({this.userNumber,});

//  push() async{
//    await Firestore.instance.collection("bazaarCategoriesMetadata").document(userNumber).setData({'categories':categories}, merge: true);
//  }

  push(String category, String subCategoryData, String subCategory) async{
    Firestore.instance.collection("bazaarCategoriesMetadata").document(userNumber).setData({}, merge: true);///creating document to avoid error document(i
    Firestore.instance.collection("bazaarCategoriesMetadata").document(userNumber).collection(category).document(subCategoryData).setData({'name' : subCategory}, merge: true);
  }
}