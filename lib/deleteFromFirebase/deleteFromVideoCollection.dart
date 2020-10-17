import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/PushToFirebase/pushToVideoCollection.dart';

class DeleteFromVideoCollection{
  String userPhoneNo;
  String categoryData;
  String subCategoryData;

  DeleteFromVideoCollection({this.categoryData, this.subCategoryData, this.userPhoneNo});

  CollectionReference categoryDataPath(String userPhoneNo){
    CollectionReference dc = PushToVideoCollection().categoryDataPath(userPhoneNo, categoryData);
    return dc;
  }

  deleteSubcategory() async{
    await categoryDataPath(userPhoneNo).document(subCategoryData).delete();
  }

}