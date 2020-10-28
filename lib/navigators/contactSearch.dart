import 'package:flutter/cupertino.dart';
import 'package:gupshop/contactSearch/contact_search.dart';
import 'package:gupshop/responsive/textConfig.dart';

class ContactSearchRoute{


  static Widget main(BuildContext context){
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;
    final String userPhoneNo = map[TextConfig.userPhoneNo];
    final String userName = map[TextConfig.userName];
    final String data = map[TextConfig.data];

    return ContactSearch(
      userName: userName,
      userPhoneNo: userPhoneNo,
      data: data,
    );
  }
}