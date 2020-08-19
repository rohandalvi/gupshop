import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateConversationMetadata{
  
  addNewMembers(String groupConversationId, List<dynamic> newList){
    print("newList in AddNewGroupMember: $newList");
    Firestore.instance.collection("conversationMetadata").document(groupConversationId).updateData({
      'members': FieldValue.arrayUnion(newList)
    });
  }

  replaceAdmin(String groupConversationId,String userNumber){
    Firestore.instance.collection("conversationMetadata").
    document(groupConversationId).updateData({'admin' : userNumber});
  }
}