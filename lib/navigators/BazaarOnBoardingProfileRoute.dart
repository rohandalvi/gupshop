import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarAdvertisement.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarLocation.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarOnBoardingProfile.dart';
import 'package:gupshop/responsive/textConfig.dart';

class BazaarOnBoardingProfileRoute{
  static Widget main(BuildContext context){
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;

    final String userPhoneNo= map[TextConfig.userPhoneNo];
    final String userName= map[TextConfig.userName];
    final List<String> listOfSubCategories=map[TextConfig.listOfSubCategories];
    final String category= map[TextConfig.category];
    final String categoryData= map[TextConfig.categoryData];
    final List<String> listOfSubCategoriesForData= map[TextConfig.listOfSubCategoriesForData];
    final List<dynamic> deleteListData= map[TextConfig.deleteListData];
    final List<dynamic> addListData= map[TextConfig.addListData];
    final Map<String, String> subCategoryMap= map[TextConfig.subCategoryMap];

    return BazaarOnBoardingProfile(
      userPhoneNo: userPhoneNo,
      userName: userName,
      category: category,
      categoryData: categoryData,
      listOfSubCategories: listOfSubCategories,
      subCategoryMap: subCategoryMap,
      listOfSubCategoriesForData: listOfSubCategoriesForData,
      addListData: addListData,
      deleteListData: deleteListData,
    );
  }
}