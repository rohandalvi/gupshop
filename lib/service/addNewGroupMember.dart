import 'package:cloud_firestore/cloud_firestore.dart';

class AddNewGroupMember{
  
  addToConversationMetadata(String groupConversationId, List<dynamic> newList){
    print("newList in AddNewGroupMember: $newList");
    Firestore.instance.collection("conversationMetadata").document(groupConversationId).updateData({
      'members': FieldValue.arrayUnion(newList)
    });
  }
}