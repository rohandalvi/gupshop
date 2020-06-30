import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteMembersFromGroup{
  deleteDocumentFromSnapshot(DocumentReference dc) async{
    ///delete document(conversationId of the group) from recentChats
    ///of the one getting deleted out of the group
    ///
    /// in case of deleting the whole group:
    /// Delete the document(documentId) from conversationMetadata
    /// Delete the document(documentId) from recentChats of all the members
    Map res = await Firestore.instance.runTransaction((Transaction myTransaction) async{
      await myTransaction.delete(dc);
    });
  }

  deleteConversationMetadata(String documentID){
    Firestore.instance.collection("conversationMetadata").document(documentID).delete();
  }

  deleteFromFriendsCollection(String number, String documentID){
    Firestore.instance.collection("friends_$number").document(documentID).delete();
  }

  deleteFromRecentChats(String friendNumber, String documentID){
    Firestore.instance.collection("recentChats").document(friendNumber).collection("conversations").document(documentID).delete();
  }

}