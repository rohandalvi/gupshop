import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetSharedPreferences{
  Future getUserPhoneNoFuture() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userPhoneNo = prefs.getString('userPhoneNo');

    print("userPhoneNo in Profile Picture: $userPhoneNo");
    print("prefs: $prefs");
    return userPhoneNo;
  }

}