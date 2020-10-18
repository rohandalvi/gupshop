import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasBasicProfileCollection.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarTrace.dart';
import 'package:gupshop/responsive/textConfig.dart';

class UpdateBazaarWalasBasicProfile{
  String userPhoneNo;
  String categoryData;
  String subCategoryData;

  UpdateBazaarWalasBasicProfile({this.categoryData, this.subCategoryData, this.userPhoneNo});

  DocumentReference path(){
    return PushToBazaarWalasBasicProfile().categoryDataPath(userPhoneNo: userPhoneNo,
        categoryData: categoryData,subCategoryData: subCategoryData);
  }


  updateVideo(String videoURL) async{
    await path().updateData({TextConfig.videoURL : videoURL});
  }

  updateLocation(LatLng location) async{
    await path().updateData({TextConfig.latitude : location.latitude, TextConfig.longitude:location.longitude});

    /// Trace:
    BazaarTrace().locationAdded(location);
  }

  updateBusinessName(String businessName ) async{
    await path().updateData({TextConfig.businessName : businessName,});

    /// Trace:
    BazaarTrace(category: categoryData, subCategory: subCategoryData).nameChange(userPhoneNo);
  }
}