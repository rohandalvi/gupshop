import 'package:cloud_firestore/cloud_firestore.dart';

class PushToMessageReadUnreadCollection{
  String userNumber;
  String messageId;
  String conversationId;

  PushToMessageReadUnreadCollection({this.userNumber, this.messageId, this.conversationId});

  pushLatestMessageId(){
    print("userNumber in pushLatestMessageId : $userNumber");
    Firestore.instance.collection("messageReadUnread").document(userNumber)
        .setData({conversationId : messageId});
  }

}