import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarCategory/bazaarIndividualCategoryListDisplay.dart';

class NavigateToBazaarIndiviudalCategoryListDisplay{
  final String bazaarWalaName;
  final String category;
  final String categoryData;
  final String bazaarWalaPhoneNo;
  final String thumbnailPicture;
  final String subCategory;
  final String subCategoryData;
  final String homeServiceText;
  final bool homeServiceBool;
  final bool showHomeServices;

  NavigateToBazaarIndiviudalCategoryListDisplay({this.bazaarWalaPhoneNo, this.category,
    this.bazaarWalaName, this.thumbnailPicture, this.subCategory, this.subCategoryData,
    this.categoryData, this.homeServiceText, this.homeServiceBool, this.showHomeServices
  });



  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BazaarIndividualCategoryListDisplay(
              bazaarWalaName: bazaarWalaName,
              bazaarWalaPhoneNo: bazaarWalaPhoneNo,
              category: category,
              categoryData: categoryData,
              subCategory: subCategory,
              subCategoryData: subCategoryData,
              thumbnailPicture: thumbnailPicture,
              homeServiceText: homeServiceText,
              homeServiceBool: homeServiceBool,
              showHomeServices: showHomeServices,
            ),//pass Name() here and pass Home()in name_screen
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BazaarIndividualCategoryListDisplay(
            bazaarWalaName: bazaarWalaName,
            bazaarWalaPhoneNo: bazaarWalaPhoneNo,
            category: category,
            categoryData: categoryData,
            subCategory: subCategory,
            subCategoryData: subCategoryData,
            thumbnailPicture: thumbnailPicture,
            homeServiceText: homeServiceText,
            homeServiceBool: homeServiceBool,
            showHomeServices: showHomeServices,
          ),//pass Name() here and pass Home()in name_screen
        )
    );
  }
}