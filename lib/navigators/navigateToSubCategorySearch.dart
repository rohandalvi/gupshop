import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarCategory/subCategorySearch.dart';


class NavigateToSubCategorySearch{
  final String userPhoneNo;
  final String category;
  final String categoryData;
  final Future<List<DocumentSnapshot>> subCategoriesListFuture;
  final List<DocumentSnapshot> subCategoriesList;
  Map<String, String> subCategoryMap;
  final String bazaarWalaName;
  final String bazaarWalaPhoneNo;

  NavigateToSubCategorySearch({this.subCategoriesList, this.subCategoriesListFuture,
    this.category, this.subCategoryMap, this.bazaarWalaName, this.bazaarWalaPhoneNo,
    this.categoryData,this.userPhoneNo
  });


  navigate(BuildContext context) async{

    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategorySearch(
              bazaarWalaPhoneNo: bazaarWalaPhoneNo,
              bazaarWalaName: bazaarWalaName,
              subCategoriesListFuture: subCategoriesListFuture,
              subCategoryMap: subCategoryMap,
              subCategoriesList: subCategoriesList,
              categoryData: categoryData,
              category: category,
            ),//pass Name() here and pass Home()in name_screen
          )
      );
    };
  }


  navigateNoBrackets(BuildContext context) async{

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubCategorySearch(
            userPhoneNo: userPhoneNo,
            bazaarWalaPhoneNo: bazaarWalaPhoneNo,
            bazaarWalaName: bazaarWalaName,
            subCategoriesListFuture: subCategoriesListFuture,
            subCategoryMap: subCategoryMap,
            subCategoriesList: subCategoriesList,
            category: category,
            categoryData: categoryData,
          ),//pass Name() here and pass Home()in name_screen
        )
    );
  }
}