import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/bazaarCategory/subCategorySearch.dart';
import 'package:gupshop/responsive/textConfig.dart';

class SubCategorySearchRoute{

  static Widget main(BuildContext context){
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;
    final String category = map[TextConfig.category];
    final String categoryData = map[TextConfig.categoryData];
    final Future<List<DocumentSnapshot>> subCategoriesListFuture = map[TextConfig.subCategoriesListFuture];
    final List<DocumentSnapshot> subCategoriesList= map[TextConfig.subCategoriesList];
    Map<String, String> subCategoryMap= map[TextConfig.subCategoryMap];
    final String bazaarWalaName= map[TextConfig.bazaarWalaName];
    final String bazaarWalaPhoneNo = map[TextConfig.bazaarWalaPhoneNo];


    return SubCategorySearch(
      bazaarWalaPhoneNo: bazaarWalaPhoneNo,
      bazaarWalaName: bazaarWalaName,
      subCategoriesListFuture: subCategoriesListFuture,
      subCategoryMap: subCategoryMap,
      subCategoriesList: subCategoriesList,
      categoryData: categoryData,
      category: category,
    );
  }
}