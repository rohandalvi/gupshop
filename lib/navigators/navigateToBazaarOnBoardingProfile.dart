import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarOnBoardingProfile.dart';
import 'package:gupshop/modules/userDetails.dart';


class NavigateToBazaarOnBoardingProfile{
  final String userPhoneNo;
  final String userName;
  final List<String> listOfSubCategories;
  final String category;
  final String categoryData;
  List<String> listOfSubCategoriesForData;

  /// for bazaarwalaBasicProfile
  final String subCategory;
  final String subCategoryData;

//  final Future<List<DocumentSnapshot>> subCategoriesListFuture;
  Map<String, String> subCategoryMap;

  NavigateToBazaarOnBoardingProfile({this.listOfSubCategories, this.category,
     this.subCategoryMap,
    this.userPhoneNo, this.userName, this.listOfSubCategoriesForData, this.categoryData,
    this.subCategoryData, this.subCategory
  });


  navigate(BuildContext context) async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    String userName = await UserDetails().getUserNameFuture();

    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BazaarOnBoardingProfile(
              userPhoneNo: userNumber,
              userName: userName,
              category: category,
              listOfSubCategories: listOfSubCategories,
              //subCategoriesListFuture: subCategoriesListFuture,
              subCategoryMap: subCategoryMap,
              listOfSubCategoriesForData: listOfSubCategoriesForData,
              subCategory: subCategory,
              subCategoryData: subCategoryData,
            ),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context) async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    String userName = await UserDetails().getUserNameFuture();

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BazaarOnBoardingProfile(
            userPhoneNo: userNumber,
            userName: userName,
            category: category,
            categoryData: categoryData,
            listOfSubCategories: listOfSubCategories,
            //subCategoriesListFuture: subCategoriesListFuture,
            subCategoryMap: subCategoryMap,
            listOfSubCategoriesForData: listOfSubCategoriesForData,
            subCategory: subCategory,
            subCategoryData: subCategoryData,
          ),
        )
    );
  }

  navigateNoBracketsPushReplacement(BuildContext context , List list) async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    String userName = await UserDetails().getUserNameFuture();

    return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BazaarOnBoardingProfile(
            userPhoneNo: userNumber,
            userName: userName,
          ),
        ),
      result: list
    );
  }
}