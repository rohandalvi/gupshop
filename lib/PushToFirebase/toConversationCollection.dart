import 'package:cloud_firestore/cloud_firestore.dart';

class ToConversationCollection{
  push(String conversationId, var data){
    Firestore.instance.collection("conversations").document(conversationId).collection("messages").add(data);
  }
}