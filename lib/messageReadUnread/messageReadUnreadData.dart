import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/retriveFromFirebase/getFromConversationCollection.dart';
import 'package:gupshop/retriveFromFirebase/getFromMessageReadUnreadCollection.dart';

/// get latest messageId of the user from messageReadUnread collection
/// get latest messageId from conversation collection
/// if both ids are not same, then that means the user has some unread messages
/// all the messages between the conversation collection and messageReadUnread collection
/// are unread


class MessageReadUnreadData{
  Timestamp conversationsLatestMessageTimestamp;
  String conversationId;
  String number;

  MessageReadUnreadData({this.conversationsLatestMessageTimestamp, this.conversationId, this.number});


  timestampDifference() async{
    /// use friendNumber as number here
    String usersLatestMessageId = await GetFromMessageReadUnreadCollection(userNumber: number, conversationId: conversationId).getLatestMessageId();
    Timestamp usersLatestMessageTimestamp = await GetFromConversationCollection(conversationId: conversationId).getTimestamp(usersLatestMessageId);
    print("usersLatestMessageTimestamp : $usersLatestMessageTimestamp");
    print("comparison : ${usersLatestMessageTimestamp.compareTo(conversationsLatestMessageTimestamp)}");
    return usersLatestMessageTimestamp.compareTo(conversationsLatestMessageTimestamp);
  }

  getLatestMessageTimeStamp(String userNumber) async{

    String usersLatestMessageId = await GetFromMessageReadUnreadCollection(userNumber: userNumber).getLatestMessageId();
    return GetFromConversationCollection().getTimestamp(usersLatestMessageId);
  }

  containsMessageId(String messageId) async{
   DocumentSnapshot dc = await Firestore.instance.collection("messageReadUnread").document(number).get();
   bool result = dc.data["messageId"].contains(messageId);
   print("result : $result");
   return result;
  }

}