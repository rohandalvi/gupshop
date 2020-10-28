import 'package:flutter/cupertino.dart';
import 'package:gupshop/onboarding/name_screen.dart';
import 'package:gupshop/responsive/textConfig.dart';

class NameScreenRoute{

  static Widget main(BuildContext context){
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;

    final String userPhoneNo = map[TextConfig.userPhoneNo];
    return NameScreen(userPhoneNo: userPhoneNo);
  }
}