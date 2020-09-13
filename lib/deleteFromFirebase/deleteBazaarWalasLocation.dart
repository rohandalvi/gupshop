import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeleteBazaarWalasLocation{
  String userPhoneNo;
  String categoryData;
  String subCategoryData;

  DeleteBazaarWalasLocation({this.categoryData, this.subCategoryData, this.userPhoneNo});


  deleteSubcategory() async{
    print("in deleteSubcategory");
    print("categoryData in deleteSubcategory : $categoryData");
    print("subCategoryData in deleteSubcategory : $subCategoryData");
    await Firestore.instance.collection("bazaarWalasLocation").document(categoryData)
        .collection(subCategoryData).document(userPhoneNo).delete();
  }

}