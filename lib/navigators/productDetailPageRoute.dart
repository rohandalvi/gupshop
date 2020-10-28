import 'package:flutter/cupertino.dart';
import 'package:gupshop/bazaarProductDetails/productDetail.dart';
import 'package:gupshop/responsive/textConfig.dart';

class ProductDetailPageRoute{
  static Widget main(BuildContext context){
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;

    final String category= map[TextConfig.category];
    final String categoryData= map[TextConfig.categoryData];
    final String bazaarWalaName= map[TextConfig.bazaarWalaName];
    final String bazaarWalaPhoneNo= map[TextConfig.bazaarWalaPhoneNo];
    final String subCategory= map[TextConfig.subCategory];
    final String subCategoryData= map[TextConfig.subCategoryData];
    final String homeServiceText= map[TextConfig.homeServiceText];
    final bool homeServiceBool= map[TextConfig.homeServiceBool];
    final bool sendHome= map[TextConfig.sendHome];


    return ProductDetail(
      sendHome: sendHome,
      productWalaNumber: bazaarWalaPhoneNo,
      productWalaName: bazaarWalaName,
      category: category,
      categoryData: categoryData,
      subCategory: subCategory,
      subCategoryData: subCategoryData,
      homeServiceBool: homeServiceBool,
      homeServiceText: homeServiceText,
    );
  }
}