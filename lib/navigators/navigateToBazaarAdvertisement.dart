import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarAdvertisement.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarOnBoardingProfile.dart';
import 'package:gupshop/modules/userDetails.dart';


class NavigateToBazaarAdvertisement{
  final String userPhoneNo;
  final String userName;
  final List<String> listOfSubCategories;
  final String category;
  final String categoryData;
  List<String> listOfSubCategoriesForData;
  final List<dynamic> deleteListData;
  final List<dynamic> addListData;

  /// for bazaarwalaBasicProfile
  final String subCategory;
  final String subCategoryData;

//  final Future<List<DocumentSnapshot>> subCategoriesListFuture;
  Map<String, String> subCategoryMap;

  NavigateToBazaarAdvertisement({this.listOfSubCategories, this.category,
    this.subCategoryMap,
    this.userPhoneNo, this.userName, this.listOfSubCategoriesForData, this.categoryData,
    this.subCategoryData, this.subCategory, this.addListData, this.deleteListData
  });


  navigate(BuildContext context) async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    String userName = await UserDetails().getUserNameFuture();

    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BazaarAdvertisement(
              userPhoneNo: userNumber,
              userName: userName,
              category: category,
              listOfSubCategories: listOfSubCategories,
              //subCategoriesListFuture: subCategoriesListFuture,
              subCategoryMap: subCategoryMap,
              listOfSubCategoriesForData: listOfSubCategoriesForData,
              addListData: addListData,
              deleteListData: deleteListData,
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
          builder: (context) => BazaarAdvertisement(
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
          ),
        )
    );
  }
}