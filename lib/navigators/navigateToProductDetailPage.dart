import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/productDetail.dart';
import 'package:gupshop/modules/userDetails.dart';

class NavigateToProductDetailPage {
  String category;
  String categoryData;
  String bazaarWalaName;
  String bazaarWalaPhoneNo;
  String subCategory;
  final String subCategoryData;
  final String homeServiceText;
  final bool homeServiceBool;

  NavigateToProductDetailPage({this.category,this.bazaarWalaPhoneNo, this.bazaarWalaName, this.subCategory,
    this.subCategoryData, this.categoryData,
    this.homeServiceBool, this.homeServiceText,
  });

  navigate(BuildContext context) async {
//    String userNumber = await UserDetails().getUserPhoneNoFuture();
//    String userName = await UserDetails().getUserNameFuture();

    return () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductDetail(
                  productWalaNumber: bazaarWalaPhoneNo,
                  productWalaName: bazaarWalaName,
                  category: category,
                  categoryData: categoryData,
                  subCategory: subCategory,
                  subCategoryData: subCategoryData,
                  homeServiceBool: homeServiceBool,
                  homeServiceText: homeServiceText,
                ),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context) async {
//    String userNumber = await UserDetails().getUserPhoneNoFuture();
//    String userName = await UserDetails().getUserNameFuture();

  print("category in NavigateToProductDetailPage : $category");
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProductDetail(
                productWalaNumber: bazaarWalaPhoneNo,
                productWalaName: bazaarWalaName,
                category: category,
                categoryData: categoryData,
                subCategory: subCategory,
                subCategoryData: subCategoryData,
                homeServiceBool: homeServiceBool,
                homeServiceText: homeServiceText,
              ),
        )
    );
  }
}