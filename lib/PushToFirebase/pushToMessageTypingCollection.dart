import 'package:cloud_firestore/cloud_firestore.dart';

class PushToMessageTypingCollection{
  String conversationId;
  String userNumber;

  PushToMessageTypingCollection({this.conversationId, this.userNumber});

  pushTypingStatus(){
//    Firestore.instance.collection("messageTyping").document(userNumber)
//        .setData({}, merge: true);
  List<String> members = new List();
  members.add(userNumber);

    Firestore.instance.collection("messageTyping").document(conversationId)
        .setData({'members': members}, merge: true);
  }
}