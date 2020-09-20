import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/navigators/navigateToBazaarLocation.dart';
import 'package:gupshop/retriveFromFirebase/getBazaarWalasBasicProfileInfo.dart';

class BazaarLocationData{
  final String userPhoneNo;
  final String userName;
  final List<String> listOfSubCategories;
  final String category;
  final String categoryData;
  List<String> listOfSubCategoriesForData;
  final List<dynamic> deleteListData;
  final List<dynamic> addListData;
  final bool videoChanged;
  final String videoURL;
  final String aSubCategoryData;
  Map<String, String> subCategoryMap;

  double databaseLatitude;
  double databaseLongitude;
  String addressName;
  double radius;
  LatLng location;
  bool locationNotNull;

  BazaarLocationData({this.userPhoneNo, this.userName,
    this.category, this.listOfSubCategories, this.listOfSubCategoriesForData,
    this.subCategoryMap,this.categoryData,
    this.addListData, this.deleteListData,
    this.videoURL, this.videoChanged, this.aSubCategoryData,
    this.addressName, this.location, this.databaseLongitude,
    this.databaseLatitude,
    this.locationNotNull, this.radius
  });

  main(BuildContext context) async{
    await getLocationDetails();

//    return NavigateToBazaarLocation(
//        category:category,
//        categoryData: categoryData,
//        subCategoryMap:subCategoryMap,
//        userName: userName,
//        userPhoneNo: userPhoneNo,
//        addListData:addListData,
//        deleteListData:deleteListData,
//        videoChanged: videoChanged,
//        videoURL: videoURL,
//        aSubCategoryData: aSubCategoryData
//    ).navigateNoBrackets(context);
  }

  getLocationDetails() async{
    Map data = await GetBazaarWalasBasicProfileInfo(
      userNumber: userPhoneNo,
      categoryData: categoryData,
      subCategoryData: aSubCategoryData,
    ).getLocationRadiusAddressName();

    if(data != null){
      databaseLongitude = data["longitude"];
      databaseLatitude = data["latitude"];
      addressName = data["addressName"];
      radius =data["radius"];

      location = new LatLng(databaseLatitude, databaseLongitude);
      locationNotNull = true;

      print("addressName in locationAddDisplay : $addressName");
    }
  }

}