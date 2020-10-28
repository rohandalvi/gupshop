import 'package:flutter/cupertino.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/individualChat/individualChatAppBar.dart';
import 'package:gupshop/modules/Presence.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/service/conversation_service.dart';

class IndividualChatAppBarRoute{

  static Widget main(BuildContext context) {
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;

    String userName= map[TextConfig.userName];
    String userPhoneNo= map[TextConfig.userPhoneNo];
    bool groupExits= map[TextConfig.groupExists];
    String friendName= map[TextConfig.friendName];
    String friendN= map[TextConfig.friendNumber];
    String conversationId= map[TextConfig.conversationId];
    bool notGroupMemberAnymore= map[TextConfig.notAGroupMemberAnymore];
    List<dynamic> listOfFriendNumbers= map[TextConfig.listOfFriendNumbers];
    final Presence presence= map[TextConfig.presence];
    ConversationService conversationService= map[TextConfig.conversationService];
    Map<String, ChatListCache> chatListCache= map[TextConfig.chatListCache];

    return IndividualChatAppBar(
      chatListCache : chatListCache,
      userPhoneNo: userPhoneNo,
      userName: userName,
      groupExits: groupExits,
      friendName: friendName,
      friendN: friendN,
      conversationId: conversationId,
      notGroupMemberAnymore: notGroupMemberAnymore,
      listOfFriendNumbers: listOfFriendNumbers,
      presence: presence,
      conversationService: conversationService,
    );
  }

}