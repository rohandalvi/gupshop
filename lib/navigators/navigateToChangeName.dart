import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarProductDetails/changeName.dart';


class NavigateToChangeName{
  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeName(),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context) async{
    bool result =  await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeName(),
        )
    );

    return result;
  }
}