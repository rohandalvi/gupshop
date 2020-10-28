import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/bazaarOnBoarding/changeBazaarWalasPicturesFetchDataAndDisplay.dart';
import 'package:gupshop/responsive/textConfig.dart';

class ChangeBazaarPicturesFetchAndDisplayRoute{

  static Widget main(BuildContext context) {
    Map<String, dynamic> map = ModalRoute.of(context).settings.arguments;

    final List<String> subCategoriesList = map[TextConfig.subCategoriesList];
    final Map<String, String> subCategoryMap= map[TextConfig.subCategoryMap];
    final String userName= map[TextConfig.userName];
    final String userPhoneNo= map[TextConfig.userPhoneNo];
    final String category= map[TextConfig.category];
    final String categoryData= map[TextConfig.categoryData];
    final List<String> subCategoriesListData= map[TextConfig.subCategoriesListData];
    final List<dynamic> deleteListData= map[TextConfig.deleteListData];
    final List<dynamic> addListData= map[TextConfig.addListData];
    final bool videoChanged= map[TextConfig.videoChanged];
    final bool locationChanged= map[TextConfig.locationChanged];
    final String videoURL= map[TextConfig.videoURL];
    final LatLng location= map[TextConfig.location];
    final double radius= map[TextConfig.radius];
    final bool isBazaarwala= map[TextConfig.isBazaarwala];
    final String aSubCategoryData= map[TextConfig.aSubCategoryData];
    final Map<String, bool> homeServiceMap= map[TextConfig.homeServiceMap];

      return ChangeBazaarWalasPicturesFetchDataAndDisplay(
        categoryData: categoryData,
        category: category,
        subCategoriesList: subCategoriesList,
        subCategoryMap: subCategoryMap,
        userName: userName,
        userPhoneNo: userPhoneNo,
        subCategoriesListData: subCategoriesListData,
        addListData: addListData,
        deleteListData: deleteListData,
        videoURL: videoURL,
        videoChanged: videoChanged,
        location: location,
        locationChanged: locationChanged,
        radius: radius,
        aSubCategoryData: aSubCategoryData,
        homeServiceMap: homeServiceMap,
        isBazaarwala: isBazaarwala,
      );
  }

}