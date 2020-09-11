import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeleteFromBazaarWalasBasicProfile{
  String userPhoneNo;
  String categoryData;
  String subCategoryData;

  DeleteFromBazaarWalasBasicProfile({this.categoryData, this.subCategoryData, this.userPhoneNo});


  deleteSubcategory() async{
    await Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo)
        .collection(categoryData).document(subCategoryData).delete();
  }

}