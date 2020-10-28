import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarOnBoarding/subCategoriesCheckBox.dart';
import 'package:gupshop/bazaarOnBoarding/subCategoryCheckBoxData.dart';

class NavigateToBazaarSubCategoriesCheckBoxData{
  final Future<List<DocumentSnapshot>> subCategoriesListFuture;
  final List<DocumentSnapshot> subCategoriesList;
  final String category;
  final String categoryData;
  Map<String, String> subCategoryMap;

  NavigateToBazaarSubCategoriesCheckBoxData({this.subCategoriesList, this.subCategoriesListFuture,
    this.category, this.subCategoryMap, this.categoryData});


  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategoryCheckBoxData(
              subCategoriesList: subCategoriesList,
              subCategoriesListFuture: subCategoriesListFuture,
              category: category,
              categoryData: categoryData,
            ),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubCategoryCheckBoxData(
            subCategoriesList: subCategoriesList,
            subCategoriesListFuture: subCategoriesListFuture,
            category:  category,
            subCategoryMap: subCategoryMap,
            categoryData: categoryData,
          ),
        )
    );
  }
}