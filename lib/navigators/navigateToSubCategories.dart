import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarOnBoarding/subCategories.dart';

class NavigateToBazaarSubCategories{
  final Future<List<DocumentSnapshot>> subCategoriesListFuture;
  final List<DocumentSnapshot> subCategoriesList;

  NavigateToBazaarSubCategories({this.subCategoriesList, this.subCategoriesListFuture});


  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategories(subCategoriesList: subCategoriesList,
              subCategoriesListFuture: subCategoriesListFuture,),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubCategories(subCategoriesList: subCategoriesList,
            subCategoriesListFuture: subCategoriesListFuture,),
        )
    );
  }
}