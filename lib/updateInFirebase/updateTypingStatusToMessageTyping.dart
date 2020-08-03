import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateTypingStatusToMessageTyping{
  String conversationId;
  String userNumber;

  UpdateTypingStatusToMessageTyping({this.conversationId, this.userNumber});


  update(){
    List<String> members = new List();
    members.add(userNumber);
    Firestore.instance.collection("messageTyping").document(conversationId).updateData({
      'members': FieldValue.arrayUnion(members)
    });
  }
}