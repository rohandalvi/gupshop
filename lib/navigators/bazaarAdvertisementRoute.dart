import 'package:flutter/cupertino.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarAdvertisement.dart';
import 'package:gupshop/responsive/textConfig.dart';

class BazaarAdvertisementRoute{
  static Widget main(BuildContext context){
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;

    final String userPhoneNo = map[TextConfig.userPhoneNo];
    final String userName = map[TextConfig.userName];
    final List<String> listOfSubCategories =map[TextConfig.listOfSubCategories];
    final String category= map[TextConfig.category];
    final String categoryData= map[TextConfig.categoryData];
    List<String> listOfSubCategoriesForData= map[TextConfig.listOfSubCategoriesForData];
    final List<dynamic> deleteListData= map[TextConfig.deleteListData];
    final List<dynamic> addListData= map[TextConfig.addListData];

    /// for bazaarwalaBasicProfile
    final String subCategory= map[TextConfig.subCategory];
    final String subCategoryData= map[TextConfig.subCategoryData];

    Map<String, String> subCategoryMap= map[TextConfig.subCategoryMap];
    final Map<String, dynamic> homeServiceMap= map[TextConfig.homeServiceMap];


    return BazaarAdvertisement(
      userPhoneNo: userPhoneNo,
      userName: userName,
      category: category,
      categoryData: categoryData,
      listOfSubCategories: listOfSubCategories,
      //subCategoriesListFuture: subCategoriesListFuture,
      subCategoryMap: subCategoryMap,
      listOfSubCategoriesForData: listOfSubCategoriesForData,
      addListData: addListData,
      deleteListData: deleteListData,
      homeServiceMap: homeServiceMap,
    );
  }
}