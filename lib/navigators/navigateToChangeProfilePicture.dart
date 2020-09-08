import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/modules/Presence.dart';
import 'package:gupshop/screens/changeProfilePicture.dart';
import 'package:gupshop/service/conversation_service.dart';

class NavigateChangeProfilePicture{
  String userName;
  bool viewingFriendsProfile;
  String userPhoneNo;
  String groupConversationId;
  Map<String, ChatListCache> chatListCache;
  String conversationId;

  bool groupExits;
  List<dynamic> listOfFriendNumbers;
  final Presence presence;
  ConversationService conversationService;
  String friendName;
  String friendN;
  bool notGroupMemberAnymore;
  String imageURL;

  NavigateChangeProfilePicture({@required this.userName, @required this.viewingFriendsProfile,
    @required this.userPhoneNo, this.groupConversationId, this.chatListCache, this.conversationId,
    this.listOfFriendNumbers, this.conversationService, this.groupExits, this.presence, this.friendN,
    this.friendName, this.notGroupMemberAnymore,this.imageURL
  });

  navigate(BuildContext context){
    return (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeProfilePicture(
              userName: userName,
              viewingFriendsProfile:viewingFriendsProfile,
              userPhoneNo: userPhoneNo,
              groupConversationId: groupConversationId,
              conversationId: conversationId,
              chatListCache: chatListCache,
              imageURL: imageURL,
            ),//pass Name() here and pass Home()in name_screen
          )
      );
    };
  }

  navigateNoBrackets(BuildContext context){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeProfilePicture(
            userName: userName,
            viewingFriendsProfile:viewingFriendsProfile,
            userPhoneNo: userPhoneNo,
            groupConversationId: groupConversationId,
            conversationId: conversationId,
            chatListCache: chatListCache,
            imageURL: imageURL,
          ),//pass Name() here and pass Home()in name_screen
        )
    );
  }
}