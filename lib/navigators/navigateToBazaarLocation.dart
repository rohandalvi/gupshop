import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarAdvertisement.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarLocation.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarOnBoardingProfile.dart';
import 'package:gupshop/modules/userDetails.dart';


class NavigateToBazaarLocation{
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
  final bool isBazaarWala;

  /// for bazaarwalaBasicProfile
  final String subCategory;
  final String subCategoryData;
  final Map<String, bool> homeServiceMap;

//  final Future<List<DocumentSnapshot>> subCategoriesListFuture;
  Map<String, String> subCategoryMap;
  double databaseLatitude;
  double databaseLongitude;
  String addressName;
  double radius;
  LatLng location;
  bool locationNotNull;

  NavigateToBazaarLocation({this.listOfSubCategories, this.category,
    this.subCategoryMap,
    this.userPhoneNo, this.userName, this.listOfSubCategoriesForData, this.categoryData,
    this.subCategoryData, this.subCategory, this.addListData, this.deleteListData,
    this.videoURL, this.videoChanged, this.aSubCategoryData,
    this.addressName, this.location, this.databaseLongitude,
    this.databaseLatitude,
    this.locationNotNull, this.radius, this.homeServiceMap, this.isBazaarWala
  });


  navigate(BuildContext context) async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    String userName = await UserDetails().getUserNameFuture();

    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BazaarLocation(
              userPhoneNo: userNumber,
              userName: userName,
              category: category,
              listOfSubCategories: listOfSubCategories,
              //subCategoriesListFuture: subCategoriesListFuture,
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
            ),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context) async{
    print("isBazaarWala in NavigateToBazaarLocation : ${isBazaarWala}");
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    String userName = await UserDetails().getUserNameFuture();

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BazaarLocation(
            userPhoneNo: userNumber,
            userName: userName,
            category: category,
            categoryData: categoryData,
            listOfSubCategories: listOfSubCategories,
            //subCategoriesListFuture: subCategoriesListFuture,
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
          ),
        )
    );
  }
}