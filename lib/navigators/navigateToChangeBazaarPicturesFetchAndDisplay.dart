import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/changeBazaarWalasPicturesFetchDataAndDisplay.dart';

class NavigateToChangeBazaarProfilePicturesFetchAndDisplay{
  final List<String> subCategoriesList;
  final Map<String, String> subCategoryMap;
  final String userName;
  final String userPhoneNo;
  final String category;
  final String categoryData;

  NavigateToChangeBazaarProfilePicturesFetchAndDisplay({this.subCategoriesList,
    this.category, this.subCategoryMap, this.userPhoneNo, this.userName,
    this.categoryData
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
            ),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context){
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
          ),
        )
    );
  }
}
