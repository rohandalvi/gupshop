import 'package:cloud_firestore/cloud_firestore.dart';

class PushToMessageReadUnreadCollection{
  String userNumber;
  String messageId;

  PushToMessageReadUnreadCollection({this.userNumber, this.messageId});

  pushLatestMessageId(){
    List<String> messageIdList = new List();
    messageIdList.add(messageId);
    print("members in list: $messageIdList");

    Firestore.instance.collection("messageReadUnread").document(userNumber)
        .setData({"messageId": messageIdList}, merge: true);
  }

}