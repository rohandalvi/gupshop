import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/productDetail.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/screens/home.dart';

class NavigateToHome {
  int initialIndex;

  NavigateToHome({this.initialIndex});

  navigate(BuildContext context) async {
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    String userName = await UserDetails().getUserNameFuture();

    return () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Home(
                  userPhoneNo: userNumber,
                  userName: userName,
                  initialIndex: initialIndex,
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
              Home(
                userPhoneNo: userNumber,
                userName: userName,
                initialIndex: initialIndex,
              ),
        )
    );
  }
}