import 'package:flutter/cupertino.dart';
import 'package:gupshop/address/addressListUI.dart';
import 'package:gupshop/contactSearch/contactSearchPage.dart';
import 'package:gupshop/responsive/textConfig.dart';

class ContactSearchPageRoute{


  static Widget main(BuildContext context){
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;
    final String userPhoneNo = map[TextConfig.userPhoneNo];
    final String userName = map[TextConfig.userName];
    final String data = map[TextConfig.data];

    return ContactSearchPage(
      userName: userName,
      userPhoneNo: userPhoneNo,
      data: data,
    );
  }
}