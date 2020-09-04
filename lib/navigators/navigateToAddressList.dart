import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/address/addressListUI.dart';


class NavigateToAddressList{
  final String userPhoneNo;

  NavigateToAddressList({this.userPhoneNo});


  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddressListUI(userPhoneNo: userPhoneNo,),
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context) async{
    bool result =  await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddressListUI(userPhoneNo: userPhoneNo,),
        )
    );

    return result;
  }
}