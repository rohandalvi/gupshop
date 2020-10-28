import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/bazaarOnBoarding/subCategoriesCheckBox.dart';
import 'package:gupshop/responsive/textConfig.dart';

class BazaarSubCategoriesCheckBoxRoute{
  static Widget main(BuildContext context){
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;


    final Future<List<DocumentSnapshot>> subCategoriesListFuture= map[TextConfig.subCategoriesListFuture];
    final List<DocumentSnapshot> subCategoriesList= map[TextConfig.subCategoriesList];
    final String category= map[TextConfig.category];
    final String categoryData= map[TextConfig.categoryData];
    Map<String, String> subCategoryMap= map[TextConfig.subCategoryMap];


    return SubCategoriesCheckBox(
      subCategoriesList: subCategoriesList,
      subCategoriesListFuture: subCategoriesListFuture,
      category:  category,
      subCategoryMap: subCategoryMap,
      categoryData: categoryData,
    );
  }
}