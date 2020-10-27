import 'package:flutter/cupertino.dart';
import 'package:gupshop/address/addressListUI.dart';
import 'package:gupshop/responsive/textConfig.dart';

class AddressListRoute{


  static Widget main(BuildContext context){
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;
    final String userPhoneNo = map[TextConfig.userPhoneNo];

    return AddressListUI(
      userPhoneNo: userPhoneNo,
    );
  }
}