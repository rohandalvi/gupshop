import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/messageReadUnread/messageReadUnreadData.dart';
import 'package:gupshop/retriveFromFirebase/getFromMessageReadUnreadCollection.dart';
import 'package:gupshop/widgets/customText.dart';

class ListOfFriendStatusReadStatus{
  List<dynamic> listOfFriends;
  String conversationId;
  Timestamp conversationsLatestMessageTimestamp;

  ListOfFriendStatusReadStatus({this.listOfFriends, this.conversationId, this.conversationsLatestMessageTimestamp});

  readStatus() async{
    print("listOfFriendsNumbers in ListOfFriendStatusReadStatus: $listOfFriends");
    for(int i =0; i<listOfFriends.length; i++){
      int comparison = await (
          MessageReadUnreadData(
            number: listOfFriends[i],
            conversationId: conversationId,
            conversationsLatestMessageTimestamp: conversationsLatestMessageTimestamp,
          ).timestampDifference());
      print("comparison  in readStatus : $comparison");

      if(comparison < 0) return false;
    } return true;

  }

  readStatusStream(BuildContext context, Map<String, bool>readCache, String messageId, bool isMe){
    for(int i =0; i<listOfFriends.length; i++){
      return Visibility(
        visible: isMe,
        child: StreamBuilder(
          stream: GetFromMessageReadUnreadCollection(userNumber:listOfFriends[i], conversationId: conversationId).getLatestMessageIdStream(),
          builder: (context, snapshot) {
            if(snapshot.data == null) return unreadContainer(context);
            String friendsLatestMessageId = snapshot.data[conversationId];
             return FutureBuilder(
              future: MessageReadUnreadData(conversationId: conversationId, conversationsLatestMessageTimestamp: conversationsLatestMessageTimestamp, number: listOfFriends[i],).friendReadStatus(friendsLatestMessageId),
              builder: (BuildContext context, AsyncSnapshot readSnapshot) {
                if (readSnapshot.connectionState == ConnectionState.done) {
                  bool isRead = readSnapshot.data;
                  if(isRead == true) {
                    readCache[messageId] = true;
                  }
                  return readUnreadContainer(context, isRead, isMe);
                }
                return unreadContainer(context);
              },
            );
          },
        ),
      );
    }
  }

  Container unreadContainer(BuildContext context) {
    return Container(
                width: MediaQuery.of(context).size.width,
                alignment:  Alignment.centerRight,
                padding:  EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                child: CustomText(text: 'unread',fontSize: 12,).graySubtitleItalic(),
              );
  }

  Visibility readUnreadContainer(BuildContext context, bool isRead, bool isMe) {
    return Visibility(
      visible: isMe,
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment:  Alignment.centerRight,
        padding:  EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
        child: isRead == true ? CustomText(text: 'read',).blueSubtitle() : CustomText(text: 'unread',fontSize: 12,).graySubtitleItalic(),
      ),
    );
  }

}