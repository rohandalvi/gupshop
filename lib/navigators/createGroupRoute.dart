import 'package:flutter/cupertino.dart';
import 'package:gupshop/group/createGroup.dart';
import 'package:gupshop/responsive/textConfig.dart';

class CreateGroupRoute{

  static Widget main(BuildContext context){
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;

    String userName = map[TextConfig.userName];
    String userPhoneNo= map[TextConfig.userPhoneNo];
    bool shouldAddNewGroupMember= map[TextConfig.shouldAddNewGroupMember];
    String conversationId= map[TextConfig.conversationId];


    return CreateGroup(
      userName: userName,
      userPhoneNo: userPhoneNo,
      shouldAddNewMemberToTheGroup: shouldAddNewGroupMember,
      conversationId: conversationId,
    );//pass Name() he
  }
}