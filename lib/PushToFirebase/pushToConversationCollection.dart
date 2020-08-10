import 'package:cloud_firestore/cloud_firestore.dart';

class PushToConversationCollection{
  push(var data) async{
    String conversationId = data["conversationId"];
    Firestore.instance.collection("conversations").document(conversationId).collection("messages").add(data);
  }

  pushAndReturnId(var data ) async{
    String conversationId = data["conversationId"];
    DocumentReference dr = await Firestore.instance.collection("conversations").document(conversationId).collection("messages").add(data);
    return dr.documentID;
  }
}