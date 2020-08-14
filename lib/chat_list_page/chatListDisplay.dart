import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/chat_list_page/avatarDataAndDisplay.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/chat_list_page/subtitleDataAndDisplay.dart';
import 'package:gupshop/chat_list_page/trailingDisplay.dart';
import 'package:gupshop/individualChat/individual_chat.dart';
import 'package:gupshop/image/displayAvatar.dart';
import 'package:gupshop/service/findFriendNumber.dart';
import 'package:gupshop/widgets/customText.dart';

class ChatListDisplay extends StatelessWidget {
  final String myNumber;
  final String conversationId;
  bool notAGroupMemberAnymore;
  bool groupExists;
  String friendNumber;
  List<dynamic> friendNumberList;
  List<dynamic> memberList;
  String friendName;
  final bool lastMessageIsVideo;
  final int index;
  String lastMessage;
  bool lastMessageIsImage;
  final Timestamp timeStamp;
  String myName;
  Map<String, ChatListCache> chatListCache;

  ChatListDisplay({this.myNumber, this.conversationId, this.notAGroupMemberAnymore,
    this.groupExists, this.friendNumber, this.memberList, this.friendNumberList,
    this.friendName, this.lastMessageIsVideo, this.index, this.lastMessage,
    this.lastMessageIsImage, this.timeStamp, this.myName, this.chatListCache,
  });

  @override
  Widget build(BuildContext context) {
    print("avatar cache in chatListDisplay : $chatListCache");
    return ListTile( ///main widget that creates the message box
      leading: /// leading is avatar
      /// check if the avatar is in the cache.
      /// if not, then call the futurebuilder,
      /// else return froom the cache
      chatListCache.containsKey(conversationId) ==  false ?
      FutureBuilder(
        future: getFriendPhoneNo(conversationId, myNumber),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print("no cache");

            memberList = snapshot.data["members"];

            /// if a member is removed from the group, then he should not be seeing the conversations
            /// once he enters the individual chat page
            if(memberList.contains(myNumber) == false) notAGroupMemberAnymore = true;

            if(snapshot.data["groupName"]  == null){
              groupExists = false;
              /// 1. extract memberList from conversationMetadata for navigating to individualChat
              memberList = snapshot.data["members"];
              /// 2. extract friendNumber for DisplayAvatarFromFirebase
              print("memberlist in avatarDisplay : $memberList");
              friendNumber = FindFriendNumber().friendNumber(memberList, myNumber);
              /// 3. create friendNumberList to send to individualChat
              friendNumberList = FindFriendNumber().createListOfFriends(memberList, myNumber);
            } else{
              groupExists = true;
              /// for groups, conversationId is used as documentId for
              /// getting profilePicture
              /// profile_pictures -> conversationId -> url
              friendNumberList = FindFriendNumber().createListOfFriends(memberList, myNumber);
              friendNumber = conversationId;
            }
            return DisplayAvatar()
                .displayAvatarFromProfilePictures(friendNumber, 30, 27,
                false, chatListCache, conversationId);
          }
          return DisplayAvatar().avatarPlaceholder(30, 27);
            //CircularProgressIndicator();
        },
      ) : cache(),
      //chatListCache[conversationId].circleAvatar,
      title: CustomText(text: friendName),
      subtitle: SubtitleDataAndDisplay(
        lastMessage: lastMessage,
        lastMessageIsImage: lastMessageIsImage,
        lastMessageIsVideo: lastMessageIsVideo,
        index: index,
        myNumber: myNumber,
      ),
      /// read unread icon display:
      trailing: TrailingDisplay(
        conversationId: conversationId,
        myNumber: myNumber,
        timeStamp: timeStamp,
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  IndividualChat(
                    friendName: friendName,
                    conversationId: conversationId,
                    userName: myName,
                    userPhoneNo: myNumber,
                    listOfFriendNumbers: friendNumberList,
                    notGroupMemberAnymore: notAGroupMemberAnymore,
                  ), //pass Name() here and pass Home()in name_screen
            )
        );
      },
    );
  }

  getFriendPhoneNo(String conversationId, String myNumber) async {
    DocumentSnapshot temp = await Firestore.instance.collection(
        "conversationMetadata").document(conversationId).get();
    return temp.data;
  }

  cache(){
    return chatListCache[conversationId].circleAvatar;
  }
}
