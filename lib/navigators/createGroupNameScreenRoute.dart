import 'package:flutter/cupertino.dart';
import 'package:gupshop/group/createGroupName_screen.dart';
import 'package:gupshop/responsive/textConfig.dart';

class CreateGroupNameScreenRoute{

  static Widget main(BuildContext context){
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;
    final String userPhoneNo = map[TextConfig.userPhoneNo];
    final String userName = map[TextConfig.userName];
    final List<String> listOfNumbersInAGroup = map[TextConfig.listOfNumbersInAGroup];

    return CreateGroupName_Screen(
      userName: userName,
      userPhoneNo: userPhoneNo,
      listOfNumbersInAGroup: listOfNumbersInAGroup,
    );//pass Name() here a
  }
}