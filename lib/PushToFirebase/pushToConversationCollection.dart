import 'package:cloud_firestore/cloud_firestore.dart';

class PushToConversationCollection{
  push(var data){
    String conversationId = data["conversationId"];
    Firestore.instance.collection("conversations").document(conversationId).collection("messages").add(data);
  }
}