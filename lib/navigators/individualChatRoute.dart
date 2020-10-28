import 'package:flutter/cupertino.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/individualChat/individual_chat.dart';
import 'package:gupshop/responsive/textConfig.dart';

class IndividualChatRoute{

  static Widget main(BuildContext context) {
    Map<String,dynamic> map = ModalRoute.of(context).settings.arguments;

    Map<String, ChatListCache> chatListCache = map[TextConfig.chatListCache];
    String myName = map[TextConfig.userName];
    String myNumber = map[TextConfig.userPhoneNo];
    String friendName = map[TextConfig.friendName];
    String conversationId = map[TextConfig.conversationId];
    List<dynamic> friendNumberList = map[TextConfig.friendNumberList];
    bool notAGroupMemberAnymore = map[TextConfig.notAGroupMemberAnymore];
    bool groupDeleted = map[TextConfig.groupDeleted];
    String imageURL = map[TextConfig.imageURL];
    var forwardMessage =  map[TextConfig.forwardMessage];

    return IndividualChat(
      chatListCache: chatListCache,
      friendName: friendName,
      conversationId: conversationId,
      userName: myName,
      userPhoneNo: myNumber,
      listOfFriendNumbers: friendNumberList,
      notGroupMemberAnymore: notAGroupMemberAnymore,
      groupDeleted: groupDeleted,
      imageURL: imageURL,
      forwardMessage: forwardMessage,
    );
  }

}