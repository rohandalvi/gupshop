import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/viewProfileAsBazaarWala.dart';

class NavigateToViewProfileAsBazaarWala{

//  NavigateToChangeBazaarProfilePicturesFetchAndDisplay({});

  navigate(BuildContext context){
    print("in navigate to NavigateToChangeBazaarProfilePicturesFetchAndDisplay");
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewProfileAsBazaarWala(),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewProfileAsBazaarWala(),
        )
    );
  }
}
