import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateMessageReadUnreadCollection{
  String userNumber;
  String messageId;

  UpdateMessageReadUnreadCollection({this.userNumber, this.messageId});

  update(){
    List<String> messageIdList = new List();
    messageIdList.add(messageId);
    Firestore.instance.collection("messageReadUnread").document(userNumber).updateData({
      'messageId': FieldValue.arrayUnion(messageIdList)
    });
  }

}