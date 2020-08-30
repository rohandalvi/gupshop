import 'package:cloud_firestore/cloud_firestore.dart';

class PushToCategoriesMatedata{
  String userNumber;
  List<String> categories;

  PushToCategoriesMatedata({this.userNumber, this.categories});

//  push() async{
//    await Firestore.instance.collection("bazaarCategoriesMetadata").document(userNumber).setData({'categories':categories}, merge: true);
//  }

  push(String category, String subCategory) async{
    await Firestore.instance.collection("bazaarCategoriesMetadata").document(userNumber).collection(category).document(subCategory);
  }
}