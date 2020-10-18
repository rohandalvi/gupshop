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
  String conversationsLatestMessageId;

  MessageReadUnreadData({this.conversationsLatestMessageTimestamp, this.conversationId, this.number, this.conversationsLatestMessageId});


  timestampDifferenceForReadUnread() async{
    String usersLatestMessageId = await GetFromMessageReadUnreadCollection(userNumber: number, conversationId: conversationId).getLatestMessageId();
    if(usersLatestMessageId == null ) return false; /// 1st message to a new conversation
    if(usersLatestMessageId == conversationsLatestMessageId) return true;
    return false;
  }



  timestampDifference(String usersLatestMessageId) {
    if(usersLatestMessageId == null ) return false; /// 1st message to a new conversation
    if(usersLatestMessageId == conversationsLatestMessageId) return true;
    return false;
  }


  getLatestMessageTimeStamp(String userNumber) async{
    String usersLatestMessageId = await GetFromMessageReadUnreadCollection(userNumber: userNumber).getLatestMessageId();
    return GetFromConversationCollection().getTimestamp(usersLatestMessageId);
  }

  containsMessageId(String messageId) async{
    return GetFromMessageReadUnreadCollection().containsMessageId(messageId);
//   DocumentSnapshot dc = await Firestore.instance.collection("messageReadUnread").document(number).get();
//   bool result = dc.data["messageId"].contains(messageId);
//   return result;
  }

  Future<bool> friendReadStatus(String usersLatestMessageId) async{
    /// use friendNumber as number here
    if(usersLatestMessageId == null) return false;
    Timestamp usersLatestMessageTimestamp = await GetFromConversationCollection(conversationId: conversationId).getTimestamp(usersLatestMessageId);
    int diff =  usersLatestMessageTimestamp.compareTo(conversationsLatestMessageTimestamp);
    if(diff < 0) return false;
    return true;
  }

}