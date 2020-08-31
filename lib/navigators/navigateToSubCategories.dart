import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarOnBoarding/subCategoriesCheckBox.dart';

class NavigateToBazaarSubCategories{
  final Future<List<DocumentSnapshot>> subCategoriesListFuture;
  final List<DocumentSnapshot> subCategoriesList;
  final String category;
  Map<String, String> subCategoryMap;

  NavigateToBazaarSubCategories({this.subCategoriesList, this.subCategoriesListFuture, this.category, this.subCategoryMap});


  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategoriesCheckBox(subCategoriesList: subCategoriesList,
              subCategoriesListFuture: subCategoriesListFuture, category: category,),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubCategoriesCheckBox(subCategoriesList: subCategoriesList,
            subCategoriesListFuture: subCategoriesListFuture, category:  category,
            subCategoryMap: subCategoryMap,
          ),
        )
    );
  }
}