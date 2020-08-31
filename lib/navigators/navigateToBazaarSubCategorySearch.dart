import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarCategory/subCategorySearch.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarSubCategorySearch.dart';


class NavigateToBazaarSubCategorySearch{
  final String category;
  final List<String> subCategoriesList;
  Map<String, String> subCategoryMap;
  final String bazaarWalaName;
  final String bazaarWalaPhoneNo;

  NavigateToBazaarSubCategorySearch({this.subCategoriesList,
    this.category, this.subCategoryMap, this.bazaarWalaName, this.bazaarWalaPhoneNo});


  navigate(BuildContext context) async{

    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BazaarSubCategorySearch(
              bazaarWalaPhoneNo: bazaarWalaPhoneNo,
              bazaarWalaName: bazaarWalaName,
              subCategoryMap: subCategoryMap,
              subCategoriesList: subCategoriesList,
            ),//pass Name() here and pass Home()in name_screen
          )
      );
    };
  }


  navigateNoBrackets(BuildContext context) async{

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BazaarSubCategorySearch(
            bazaarWalaPhoneNo: bazaarWalaPhoneNo,
            bazaarWalaName: bazaarWalaName,
            subCategoryMap: subCategoryMap,
            subCategoriesList: subCategoriesList,
          ),//pass Name() here and pass Home()in name_screen
        )
    );
  }
}