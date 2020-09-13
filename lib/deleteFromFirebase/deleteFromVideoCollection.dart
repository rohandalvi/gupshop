import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeleteFromVideoCollection{
  String userPhoneNo;
  String categoryData;
  String subCategoryData;

  DeleteFromVideoCollection({this.categoryData, this.subCategoryData, this.userPhoneNo});


  deleteSubcategory() async{
    await Firestore.instance.collection("videos").document(userPhoneNo)
        .collection(categoryData).document(subCategoryData).delete();
  }

}