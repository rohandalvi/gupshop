import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateConversationCollection{
  final String conversationId;
  final String documentId;
  bool isSaved;

  UpdateConversationCollection({this.conversationId, this.documentId, this.isSaved});

  update(){
    print("isSaved :$isSaved");
    Firestore.instance.collection("conversations").document(conversationId).collection("messages").document(documentId).updateData({'isSaved': isSaved});
  }
  
}