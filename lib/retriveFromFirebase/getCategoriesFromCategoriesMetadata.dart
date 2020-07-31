import 'package:cloud_firestore/cloud_firestore.dart';

class GetCategoriesFromCategoriesMetadata{
  String userNumber;

  GetCategoriesFromCategoriesMetadata({this.userNumber});

  main() async{
    DocumentSnapshot dc = await Firestore.instance.collection("bazaarCategoriesMetadata").document(userNumber).get();
    print("dc.data : ${dc.data}");
    return dc.data;
  }

}