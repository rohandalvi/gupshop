import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/modules/userDetails.dart';

class getCategoriesFromCategoriesMetadata{
  final String category;

  getCategoriesFromCategoriesMetadata({this.category});

//  Future<Map<String, List>> selectedCategories() async{
  selectedCategories() async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    QuerySnapshot dc = await Firestore.instance.collection("bazaarCategoriesMetadata")
        .document(userNumber).collection(category).getDocuments();
//    Map<String, List<dynamic>> result  = dc.data;
//    return result;
    return dc.documents;
  }

  getCategoriesLength() async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    QuerySnapshot dc = await Firestore.instance.collection("bazaarCategoriesMetadata")
        .document(userNumber).collection(category).getDocuments();
//    Map<String, dynamic> listOfCategories = dc.data;
//    print("listOfCategories : $listOfCategories");
//    return dc.data;
  }

  getSelectedCategoriesAsMap() async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    QuerySnapshot dc = await Firestore.instance.collection("bazaarCategoriesMetadata")
        .document(userNumber).collection(category).getDocuments();
    if(dc.documents != null){
      Map result = new HashMap();
      Map map =  dc.documents.asMap();
      map.forEach((key, value) {
        DocumentSnapshot nameDc = value;
        String categoryName = nameDc.data["name"];
        result[categoryName] = true;
      });
      return result;
    } return null;
  }

  getSelectedCategoriesDataAsMap() async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    QuerySnapshot dc = await Firestore.instance.collection("bazaarCategoriesMetadata")
        .document(userNumber).collection(category).getDocuments();
    if(dc.documents != null){
      Map result = new HashMap();
      Map map =  dc.documents.asMap();
      map.forEach((key, value) {
        DocumentSnapshot nameDc = value;
        String categoryName = nameDc.documentID;
        result[categoryName] = true;
      });
      return result;
    } return null;
  }

}