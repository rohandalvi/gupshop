import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/bazaarProfilePage.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/screens/home.dart';

class NavigateToBazaarProfilePage {

  navigate(BuildContext context) async {
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    String userName = await UserDetails().getUserNameFuture();

    return () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BazaarProfilePage(
                  userPhoneNo: userNumber,
                  userName: userName,
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
              BazaarProfilePage(
                userPhoneNo: userNumber,
                userName: userName,
              ),
        )
    );
  }
}