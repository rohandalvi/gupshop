import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/individualChat/individual_chat.dart';

class NavigateToIndividualChat{
  final String conversationId;
  final String userPhoneNo;
  final String userName;
  final String friendName;/// this should be a list
  final Map forwardMessage;
  final bool notGroupMemberAnymore;
  List<dynamic> listOfFriendNumbers;
  var data;
  Map<String, ChatListCache> chatListCache;


  NavigateToIndividualChat(
      {@required this.conversationId, @required this.userPhoneNo,
        @required this.userName, @required this.friendName,this.forwardMessage,
        this.listOfFriendNumbers,
        this.notGroupMemberAnymore, this.chatListCache, this.data});


  navigate(BuildContext context,
      //List<dynamic> listOfFriendNumbers
      ){
    return(){
      Navigator.push(
        context,
        MaterialPageRoute(//to send conversationId along with the navigator to the next page
          builder: (context) => IndividualChat(
            conversationId: conversationId,
            userPhoneNo: userPhoneNo,
            userName: userName,
            friendName:friendName,
            forwardMessage: data,
            listOfFriendNumbers: listOfFriendNumbers,
            notGroupMemberAnymore: notGroupMemberAnymore,
          ),
        ),
      );
    };

  }

  navigateNoBrackets(BuildContext context,
      //List<dynamic> listOfFriendNumbers
      ){
    Navigator.push(
      context,
      MaterialPageRoute(//to send conversationId along with the navigator to the next page
        builder: (context) => IndividualChat(
          conversationId: conversationId,
          userPhoneNo: userPhoneNo,
          userName: userName,
          friendName:friendName,
          forwardMessage: data,
          listOfFriendNumbers: listOfFriendNumbers,
          notGroupMemberAnymore: notGroupMemberAnymore,
        ),
      ),
    );
  }

}