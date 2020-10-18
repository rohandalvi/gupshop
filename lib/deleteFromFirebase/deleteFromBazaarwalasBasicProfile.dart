import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasBasicProfileCollection.dart';

class DeleteFromBazaarWalasBasicProfile{
  String userPhoneNo;
  String categoryData;
  String subCategoryData;

  DeleteFromBazaarWalasBasicProfile({this.categoryData, this.subCategoryData, this.userPhoneNo});


  deleteSubcategory() async{
    print("in deleteSubcategory");
    print("categoryData in deleteSubcategory : $categoryData");
    print("subCategoryData in deleteSubcategory : $subCategoryData");
    await PushToBazaarWalasBasicProfile().categoryDataPath(userPhoneNo: userPhoneNo,
        categoryData: categoryData,subCategoryData: subCategoryData).delete();
  }

}