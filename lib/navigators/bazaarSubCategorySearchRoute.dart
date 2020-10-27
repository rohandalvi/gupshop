import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarAdvertisement.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarLocation.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarOnBoardingProfile.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarSubCategorySearch.dart';
import 'package:gupshop/responsive/textConfig.dart';

class BazaarSubCategorySearchRoute{
  static Widget main(BuildContext context){
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;

    final String category = map[TextConfig.category];
    final String categoryData= map[TextConfig.categoryData];
    final List<String> subCategoriesList= map[TextConfig.subCategoriesList];
    Map<String, String> subCategoryMap= map[TextConfig.subCategoryMap];
    final String bazaarWalaName= map[TextConfig.bazaarWalaName];
    final String bazaarWalaPhoneNo= map[TextConfig.bazaarWalaPhoneNo];
    final List<String> subCategoriesListData= map[TextConfig.subCategoriesListData];

    return BazaarSubCategorySearch(
      bazaarWalaPhoneNo: bazaarWalaPhoneNo,
      bazaarWalaName: bazaarWalaName,
      subCategoryMap: subCategoryMap,
      subCategoriesList: subCategoriesList,
      category: category,
      categoryData: categoryData,
      subCategoriesListData: subCategoriesListData,
    );
  }
}