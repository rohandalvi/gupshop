import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/changeBazaarWalasPicturesFetchDataAndDisplay.dart';

class NavigateToChangeBazaarProfilePicturesFetchAndDisplay{

//  NavigateToChangeBazaarProfilePicturesFetchAndDisplay({});

  navigate(BuildContext context){
    print("in navigate to NavigateToChangeBazaarProfilePicturesFetchAndDisplay");
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeBazaarWalasPicturesFetchDataAndDisplay(),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeBazaarWalasPicturesFetchDataAndDisplay(),
        )
    );
  }
}
