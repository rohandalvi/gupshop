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
  List<String> listOfSubCategoriesForData;

//  final Future<List<DocumentSnapshot>> subCategoriesListFuture;
  Map<String, String> subCategoryMap;

  NavigateToBazaarOnBoardingProfile({this.listOfSubCategories, this.category,
     this.subCategoryMap,
    this.userPhoneNo, this.userName, this.listOfSubCategoriesForData
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
            listOfSubCategories: listOfSubCategories,
            //subCategoriesListFuture: subCategoriesListFuture,
            subCategoryMap: subCategoryMap,
            listOfSubCategoriesForData: listOfSubCategoriesForData,
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