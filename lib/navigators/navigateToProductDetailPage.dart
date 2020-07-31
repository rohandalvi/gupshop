import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/productDetail.dart';
import 'package:gupshop/modules/userDetails.dart';

class NavigateToProductDetailPage {
  String category;

  NavigateToProductDetailPage({this.category});

  navigate(BuildContext context) async {
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    String userName = await UserDetails().getUserNameFuture();

    return () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductDetail(
                  productWalaNumber: userNumber,
                  productWalaName: userName,
                  category: category,
                ),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context) async {
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    String userName = await UserDetails().getUserNameFuture();

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProductDetail(
                productWalaNumber: userNumber,
                productWalaName: userName,
                category: category,
              ),
        )
    );
  }
}