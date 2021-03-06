import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/chat_list_page/chatListDisplay.dart';
import 'package:gupshop/deleteFromFirebase/friendsCollection.dart';
import 'package:gupshop/deleteFromFirebase/deleteMembersFromGroup.dart';
import 'package:gupshop/retriveFromFirebase/conversationMetaData.dart';
import 'package:gupshop/service/conversationDetails.dart';
import 'package:gupshop/widgets/customDismissible.dart';
import 'package:gupshop/widgets/customText.dart';

class ChatListData extends StatefulWidget {
  List<DocumentSnapshot> list;
  final String myNumber;
  bool notAGroupMemberAnymore;
  bool groupExists;
  String myName;
  Map<String, ChatListCache> chatListCache;

  ChatListData({this.list, this.myNumber, this.notAGroupMemberAnymore,
    this.groupExists, this.myName, this.chatListCache,
  });

  @override
  _ChatListDataState createState() => _ChatListDataState();
}

class _ChatListDataState extends State<ChatListData> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated( ///to create the seperated view of each chat, has to be used with separatorBuilder: (context, index) => Divider
      itemCount: widget.list.length,
      itemBuilder: (context, index) {
        bool lastMessageIsVideo=false;
        bool lastMessageIsImage=false;
        String lastMessage;

        String friendName = widget.list[index].data["name"];
        if (widget.list[index].data["message"]["videoURL"] != null) {
          lastMessageIsVideo = true;
          lastMessage = widget.list[index].data["message"]["videoURL"];
        }
        else if (widget.list[index].data["message"]["imageURL"] != null) {
          lastMessageIsImage = true;
          lastMessage = widget.list[index].data["message"]["imageURL"];
        } else {
          lastMessage = widget.list[index].data["message"]["body"];
        }
        Timestamp timeStamp = widget.list[index]
            .data["message"]["timeStamp"];
       // bool read = widget.list[index].data["read"];

        String messageId = widget.list[index].data["message"]["messageId"];

        String friendNumber;
        List<dynamic> memberList;
        List<dynamic> friendNumberList;

        ///for sending to individual_chat.dart:
        String conversationId = widget.list[index].data["message"]["conversationId"];
        String documentID = widget.list[index].documentID;
        String adminNumber;

        return CustomDismissible(
          key: Key(documentID),
          documentID: documentID,
          /// onDismissed has all the delete logic:
          onDismissed: (direction) async{
            var temp = await ConversationMetaData(conversationId: conversationId).get(widget.myNumber);

            memberList = temp["members"];
            bool isGroup = await CheckIfGroup().ifThisIsAGroup(documentID);
            adminNumber = await CheckIfGroup().getAdminNumber(documentID);
            /// ToDo: not working called from DeleteChats
            ///for individualChat, only delete from my recentChats
            DeleteMembersFromGroup().deleteDocumentFromSnapshot(widget.list[index].reference);///recentChats
            if(direction == DismissDirection.startToEnd &&  isGroup == true && adminNumber == widget.myNumber){
              /// also delete from profilePictures

              //DeleteMembersFromGroup().deleteConversationMetadata(documentID);///conversationMetadata
              FriendsCollection().deleteFromFriendsCollection(widget.myNumber, documentID);///friends collection
              DeleteMembersFromGroup().deleteAGroupMember(widget.myNumber, documentID);
              /// delete from the recentChats of all members(memberList, which includes me too)
              /// delete from the friends collection of all members(memberList, which includes me too)
              for(int i=0; i<memberList.length; i++){
                DeleteMembersFromGroup().deleteFromFriendsCollection(memberList[i], documentID);
                DeleteMembersFromGroup().deleteAGroupMember(memberList[i], documentID);
                //DeleteMembersFromGroup().deleteFromRecentChats(memberList[i], documentID);
              }

              /// add group delete notification here
            }
          },
          child: ChatListDisplay(
            chatListCache: widget.chatListCache,
            myNumber: widget.myNumber,
            conversationId: conversationId,
            notAGroupMemberAnymore: widget.notAGroupMemberAnymore,
            groupExists: widget.groupExists,
            friendNumber: friendNumber,
            friendNumberList: friendNumberList,
            memberList: memberList,
            lastMessage: lastMessage,
            lastMessageIsImage: lastMessageIsImage,
            lastMessageIsVideo: lastMessageIsVideo,
            index: index,
            timeStamp: timeStamp,
            myName: widget.myName,
            friendName: friendName,
            conversationsLatestMessageId: messageId,
            //imageURL: ,
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
