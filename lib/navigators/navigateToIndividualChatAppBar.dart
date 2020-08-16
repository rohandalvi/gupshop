import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/individualChat/individualChatAppBar.dart';
import 'package:gupshop/modules/Presence.dart';
import 'package:gupshop/service/conversation_service.dart';

class NavigateToIndividualChatAppBar{
  String userName;
  String userPhoneNo;
  bool groupExits;
  String friendName;
  String friendN;
  String conversationId;
  bool notGroupMemberAnymore;
  List<dynamic> listOfFriendNumbers;
  final Presence presence;
  ConversationService conversationService;
  Map<String, ChatListCache> chatListCache;


  NavigateToIndividualChatAppBar({this.userName, this.userPhoneNo, this.groupExits,
    this.friendName, this.friendN, this.conversationId, this.notGroupMemberAnymore,
    this.listOfFriendNumbers,this.presence, this.conversationService, this.chatListCache,
  });

  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IndividualChatAppBar(
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
            ),//pass Name() here and pass Home()in name_screen
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IndividualChatAppBar(
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
          ),//pass Name() here and pass Home()in name_screen
        )
    );
  }
}