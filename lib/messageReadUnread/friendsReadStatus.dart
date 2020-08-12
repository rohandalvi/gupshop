import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/messageReadUnread/messageReadUnreadData.dart';
import 'package:gupshop/messageReadUnread/readUnreadDisplay.dart';
import 'package:gupshop/messageReadUnread/unreadDisplay.dart';
import 'package:gupshop/retriveFromFirebase/getFromMessageReadUnreadCollection.dart';
import 'package:gupshop/widgets/customText.dart';

class FriendReadStatus{
  List<dynamic> listOfFriends;
  String conversationId;
  Timestamp conversationsLatestMessageTimestamp;

  FriendReadStatus({this.listOfFriends, this.conversationId, this.conversationsLatestMessageTimestamp});

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

  readStream(BuildContext context, Map<String, bool>readCache, String messageId, bool isMe){
    for(int i =0; i<listOfFriends.length; i++){
      return Visibility(
        visible: isMe,
        child: StreamBuilder(
          stream: GetFromMessageReadUnreadCollection(userNumber:listOfFriends[i], conversationId: conversationId).getLatestMessageIdStream(),
          builder: (context, snapshot) {
            if(snapshot.data == null) return UnreadDisplay(context: context);
            String friendsLatestMessageId = snapshot.data[conversationId];
             return FutureBuilder(
              future: MessageReadUnreadData(conversationId: conversationId, conversationsLatestMessageTimestamp: conversationsLatestMessageTimestamp, number: listOfFriends[i],).friendReadStatus(friendsLatestMessageId),
              builder: (BuildContext context, AsyncSnapshot readSnapshot) {
                if (readSnapshot.connectionState == ConnectionState.done) {
                  bool isRead = readSnapshot.data;
                  if(isRead == true) {
                    readCache[messageId] = true;
                  }
                  return ReadUnreadDisplay(context: context, isRead: isRead, isMe: isMe);
                }
                return UnreadDisplay(context: context);
              },
            );
          },
        ),
      );
    }
  }

}


