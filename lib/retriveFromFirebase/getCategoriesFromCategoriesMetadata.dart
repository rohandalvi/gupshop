import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/PushToFirebase/pushToCategoriesMetadata.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/responsive/textConfig.dart';

class GetCategoriesFromCategoriesMetadata{
  final String category;

  GetCategoriesFromCategoriesMetadata({this.category});

  CollectionReference path(String userNumber){
    CollectionReference cr = PushToCategoriesMatedata().path(userNumber).collection(category);
    return cr;
  }


  selectedCategories() async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    QuerySnapshot dc = await path(userNumber).getDocuments();
    return dc.documents;
  }

  getCategoriesLength() async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    QuerySnapshot dc = await path(userNumber).getDocuments();
//    Map<String, dynamic> listOfCategories = dc.data;
//    print("listOfCategories : $listOfCategories");
//    return dc.data;
  }

  getSelectedCategoriesAsMap() async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    QuerySnapshot dc = await path(userNumber).getDocuments();
    if(dc.documents != null){
      Map result = new HashMap();
      Map map =  dc.documents.asMap();
      map.forEach((key, value) {
        DocumentSnapshot nameDc = value;
        String categoryName = nameDc.data[TextConfig.name];
        result[categoryName] = true;
      });
      return result;
    } return null;
  }

  getSelectedCategoriesDataAsMap() async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    QuerySnapshot querySnapshot = await path(userNumber).getDocuments();
    if(querySnapshot.documents != null){
      Map result = new HashMap();
      Map map =  querySnapshot.documents.asMap();
      map.forEach((key, value) {
        DocumentSnapshot nameDc = value;
        String categoryName = nameDc.documentID;
        result[categoryName] = true;
      });
      return result;
    } return null;
  }

}