import 'package:cloud_firestore/cloud_firestore.dart';

class BazaarCategoryTypesAndImages{

  getStream(){
    return Firestore.instance.collection("bazaarCategoryTypesAndImages").snapshots();
  }

  Future<List<DocumentSnapshot>> getSubCategories(String category) async{
    QuerySnapshot cr = await Firestore.instance.collection("bazaarCategoryTypesAndImages")
        .document(category).collection('subCategories').getDocuments();
    List<DocumentSnapshot> list = cr.documents;
    if(list.isEmpty == true) return null;
    list.forEach((element) {
      print("name in get : ${element.data["name"]}");
    });
    return list;
  }

}