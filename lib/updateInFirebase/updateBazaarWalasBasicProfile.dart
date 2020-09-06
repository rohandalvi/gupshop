import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UpdateBazaarWalasBasicProfile{
  String userPhoneNo;
  String categoryData;
  String subCategoryData;

  UpdateBazaarWalasBasicProfile({this.categoryData, this.subCategoryData, this.userPhoneNo});


  updateVideo(String videoURL) async{
    await Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo)
        .collection(categoryData).document(subCategoryData).updateData({'videoURL' : videoURL});
  }

  updateLocation(LatLng location) async{
    await Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo)
        .collection(categoryData).document(subCategoryData).updateData({'latitude' : location.latitude, 'longitude':location.longitude});
  }
}