import 'package:flutter/cupertino.dart';
import 'package:gupshop/bazaarCategory/bazaarIndividualCategoryListData.dart';
import 'package:gupshop/responsive/textConfig.dart';

class BazaarIndividualCategoryDataRoute{

  static Widget main(BuildContext context) {
    Map<String, dynamic> map = ModalRoute.of(context).settings.arguments;

    final String category=map[TextConfig.category];
    final String categoryData=map[TextConfig.categoryData];
    final String subCategory=map[TextConfig.subCategory];
    final String subCategoryData=map[TextConfig.subCategoryData];
    final bool showHomeService=map[TextConfig.showHomeService];
    final List<String> userGeohash=map[TextConfig.userGeohash];
    final String addressName=map[TextConfig.addressName];

    return BazaarIndividualCategoryListData(
      category : category,
      categoryData: categoryData,
      subCategory: subCategory,
      subCategoryData: subCategoryData,
      showHomeService: showHomeService,
      userGeohash: userGeohash,
      addressName: addressName,
    );//pass Name() here
  }

}