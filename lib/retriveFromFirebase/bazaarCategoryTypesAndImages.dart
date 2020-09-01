import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class BazaarCategoryTypesAndImages{

  getStream(){
    return Firestore.instance.collection("bazaarCategoryTypesAndImages").snapshots();
    //return Firestore.instance.collection("bazaarCategoryTypesAndImages").document(category).collection('subCategories').snapshots();
  }


  getListOfDocumnets(String category) async{
    QuerySnapshot cr = await Firestore.instance.collection("bazaarCategoryTypesAndImages")
        .document(category).collection('subCategories').getDocuments();
    List<DocumentSnapshot> list = cr.documents;
    return list;
  }

  Future<List<DocumentSnapshot>> getSubCategories(String category) async{
    List<DocumentSnapshot> list = await getListOfDocumnets(category);

    if(list.isEmpty == true) return null;
    return list;
  }

  getSubCategoriesMap(String category) async{
    Map<String, String> subCategoryMap = new HashMap();

    List<DocumentSnapshot> list = await getListOfDocumnets(category);

    if(list.isEmpty == true) return null;
    list.forEach((element) {
      String categoryNameForData = element.documentID;
      String catergoryName = element.data["name"];
      subCategoryMap[catergoryName] = categoryNameForData;
    });

    return subCategoryMap;
  }

}