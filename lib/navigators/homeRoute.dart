import 'package:flutter/cupertino.dart';
import 'package:gupshop/home/home.dart';
import 'package:gupshop/responsive/textConfig.dart';

class HomeRoute{

  static Widget main(BuildContext context) {
    Map<String, dynamic> map = ModalRoute.of(context).settings.arguments;

    int initialIndex=map[TextConfig.initialIndex];
    String userNumber = map[TextConfig.userPhoneNo];
    String userName = map[TextConfig.userName];

    return Home(
      userPhoneNo: userNumber,
      userName: userName,
      initialIndex: initialIndex,
    );
  }

}