import 'package:flutter/cupertino.dart';
import 'package:gupshop/news/newsComposer.dart';
import 'package:gupshop/responsive/textConfig.dart';

class NewsComposerRoute{
  static Widget main(BuildContext context){
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;

    bool groupExits= map[TextConfig.groupExists];
    String friendN= map[TextConfig.friendNumber];
    String userPhoneNo= map[TextConfig.userPhoneNo];
    String userName= map[TextConfig.userName];
    List<dynamic> listOfFriendNumbers= map[TextConfig.listOfFriendNumbers];
    String conversationId= map[TextConfig.conversationId];
    String groupName= map[TextConfig.groupName];
    String value= map[TextConfig.value];
    TextEditingController controller= map[TextConfig.controller];
    ScrollController listScrollController= map[TextConfig.listScrollController];

    return NewsComposer(
      groupExits : groupExits,
      friendN : friendN,
      userPhoneNo : userPhoneNo,
      userName : userName,
      listOfFriendNumbers : listOfFriendNumbers,
      conversationId : conversationId,
      groupName : groupName,
      value : value,
      controller : controller,
      listScrollController : listScrollController,
    );
  }
}