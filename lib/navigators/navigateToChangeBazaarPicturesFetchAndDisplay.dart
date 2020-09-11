import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/bazaarOnBoarding/changeBazaarWalasPicturesFetchDataAndDisplay.dart';

class NavigateToChangeBazaarProfilePicturesFetchAndDisplay{
  final List<String> subCategoriesList;
  final Map<String, String> subCategoryMap;
  final String userName;
  final String userPhoneNo;
  final String category;
  final String categoryData;
  final List<String> subCategoriesListData;
  final List<dynamic> deleteListData;
  final List<dynamic> addListData;
  final bool videoChanged;
  final bool locationChanged;
  final String videoURL;
  final LatLng location;
  final double radius;
  final bool isBazaarwala;

  NavigateToChangeBazaarProfilePicturesFetchAndDisplay({this.subCategoriesList,
    this.category, this.subCategoryMap, this.userPhoneNo, this.userName,
    this.categoryData, this.subCategoriesListData,this.addListData, this.deleteListData,
    this.locationChanged, this.videoChanged,
    this.location, this.videoURL, this.radius, this.isBazaarwala
  });

  navigate(BuildContext context){
    print("in navigate to NavigateToChangeBazaarProfilePicturesFetchAndDisplay");
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeBazaarWalasPicturesFetchDataAndDisplay(
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

            ),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context){
    print("videoURL in navigateNoBrackets : $videoURL");

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeBazaarWalasPicturesFetchDataAndDisplay(
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
          ),
        )
    );
  }
}
