import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/chat_list_page/chatListDisplay.dart';
import 'package:gupshop/deleteFromFirebase/deleteHelper.dart';
import 'package:gupshop/deleteFromFirebase/deleteMembersFromGroup.dart';
import 'package:gupshop/service/conversationDetails.dart';
import 'package:gupshop/widgets/customDismissible.dart';

class ChatListData extends StatelessWidget {
  List<DocumentSnapshot> list;
  final String myNumber;
  bool notAGroupMemberAnymore;
  bool groupExists;
  String myName;

  ChatListData({this.list, this.myNumber, this.notAGroupMemberAnymore,
    this.groupExists, this.myName,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated( ///to create the seperated view of each chat, has to be used with separatorBuilder: (context, index) => Divider
      itemCount: list.length,
      itemBuilder: (context, index) {
        bool lastMessageIsVideo=false;
        bool lastMessageIsImage=false;
        String lastMessage;

        String friendName = list[index].data["name"];
        if (list[index].data["message"]["videoURL"] != null) {
          lastMessageIsVideo = true;
          lastMessage = list[index].data["message"]["videoURL"];
        }
        else if (list[index].data["message"]["imageURL"] != null) {
          lastMessageIsImage = true;
          lastMessage = list[index].data["message"]["imageURL"];
        } else {
          lastMessage = list[index].data["message"]["body"];
        }
        Timestamp timeStamp = list[index]
            .data["message"]["timeStamp"];
        bool read = list[index].data["read"];

        String friendNumber;
        List<dynamic> memberList;
        List<dynamic> friendNumberList;

        ///for sending to individual_chat.dart:
        String conversationId = list[index].data["message"]["conversationId"];
        print("conversations last message : $lastMessage ");
        print("conversations last messageId : ${list[index]
            .data["message"]["messageId"]} ");

        String documentID = list[index].documentID;
        String adminNumber;

        return CustomDismissible(
          key: Key(documentID),
          documentID: documentID,
          /// onDismissed has all the delete logic:
          onDismissed: (direction) async{
            bool isGroup = await CheckIfGroup().ifThisIsAGroup(documentID);
            adminNumber = await CheckIfGroup().getAdminNumber(documentID);
            /// ToDo: not working called from DeleteChats
            ///for individualChat, only delete from my recentChats
            DeleteMembersFromGroup().deleteDocumentFromSnapshot(list[index].reference);///recentChats
            if(direction == DismissDirection.startToEnd &&  isGroup == true && adminNumber == myNumber){
              /// also delete from profilePictures

              DeleteMembersFromGroup().deleteConversationMetadata(documentID);///conversationMetadata
              DeleteHelper().deleteFromFriendsCollection(myNumber, documentID);///friends collection
              /// delete from the recentChats of all members(memberList, which includes me too)
              /// delete from the friends collection of all members(memberList, which includes me too)
              for(int i=0; i<memberList.length; i++){
                DeleteMembersFromGroup().deleteFromFriendsCollection(memberList[i], documentID);
                DeleteMembersFromGroup().deleteFromRecentChats(memberList[i], documentID);
              }
            }
          },
          child: ChatListDisplay(
            myNumber: myNumber,
            conversationId: conversationId,
            notAGroupMemberAnymore: notAGroupMemberAnymore,
            groupExists: groupExists,
            friendNumber: friendNumber,
            friendNumberList: friendNumberList,
            memberList: memberList,
            lastMessage: lastMessage,
            lastMessageIsImage: lastMessageIsImage,
            lastMessageIsVideo: lastMessageIsVideo,
            index: index,
            timeStamp: timeStamp,
            myName: myName,
            friendName: friendName,
          ),
        );
      },
      separatorBuilder: (context, index) =>
          Divider( //to divide the chat list
            color: Colors.white,
          ),
    );
  }
}
