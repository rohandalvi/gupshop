import 'package:cloud_firestore/cloud_firestore.dart';

class PushToCategoriesMatedata{
  String userNumber;
  List<String> categories;

  PushToCategoriesMatedata({this.userNumber, this.categories});

  push() async{
    print("in PushToCategoriesMatedata");
    print("categories : $categories");
    await Firestore.instance.collection("bazaarCategoriesMetadata").document(userNumber).setData({'categories':categories}, merge: true);
  }
}