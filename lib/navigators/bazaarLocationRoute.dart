import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarAdvertisement.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarLocation.dart';
import 'package:gupshop/responsive/textConfig.dart';

class BazaarLocationRoute{
  static Widget main(BuildContext context){
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;

    final String userPhoneNo= map[TextConfig.userPhoneNo];
    final String userName= map[TextConfig.userName];
    final List<String> listOfSubCategories=map[TextConfig.listOfSubCategories];
    final String category= map[TextConfig.category];
    final String categoryData= map[TextConfig.categoryData];
    List<String> listOfSubCategoriesForData= map[TextConfig.listOfSubCategoriesForData];
    final List<dynamic> deleteListData= map[TextConfig.deleteListData];
    final List<dynamic> addListData= map[TextConfig.addListData];
    final bool videoChanged= map[TextConfig.videoChanged];
    final String videoURL= map[TextConfig.videoURL];
    final String aSubCategoryData= map[TextConfig.aSubCategoryData];
    final bool isBazaarWala= map[TextConfig.isBazaarWala];

    /// for bazaarwalaBasicProfile
    final Map<String, bool> homeServiceMap= map[TextConfig.homeServiceMap];

    Map<String, String> subCategoryMap= map[TextConfig.subCategoryMap];
    double databaseLatitude= map[TextConfig.databaseLatitude];
    double databaseLongitude= map[TextConfig.databaseLongitude];
    String addressName= map[TextConfig.addressName];
    double radius= map[TextConfig.radius];
    LatLng location= map[TextConfig.location];
    bool locationNotNull= map[TextConfig.locationNotNull];


    return BazaarLocation(
      userPhoneNo: userPhoneNo,
      userName: userName,
      category: category,
      categoryData: categoryData,
      listOfSubCategories: listOfSubCategories,
      subCategoryMap: subCategoryMap,
      listOfSubCategoriesForData: listOfSubCategoriesForData,
      addListData: addListData,
      deleteListData: deleteListData,
      videoURL: videoURL,
      videoChanged: videoChanged,
      aSubCategoryData: aSubCategoryData,
      databaseLatitude: databaseLatitude,
      databaseLongitude: databaseLongitude,
      addressName: addressName,
      radius: radius,
      location: location,
      locationNotNull: locationNotNull,
      homeServiceMap: homeServiceMap,
      isBazaarWala: isBazaarWala,
    );
  }
}