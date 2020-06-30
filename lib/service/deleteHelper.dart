import 'package:cloud_firestore/cloud_firestore.dart';
import 'deleteMembersFromGroup.dart';

class DeleteHelper{
  deleteFromRecentChats(String friendNumber, String documentID){
    DocumentReference deleteConversationFromRecentChats = Firestore.instance.collection("recentChats").document(friendNumber).collection("conversations").document(documentID);

    DeleteMembersFromGroup().deleteDocumentFromSnapshot(deleteConversationFromRecentChats);
  }

  deleteFromFriendsCollection(String friendNumber, String documentID){
    DocumentReference deleteFriendFromFriendsCollection = Firestore.instance.collection("friends_$friendNumber").document(documentID);
    DeleteMembersFromGroup().deleteDocumentFromSnapshot(deleteFriendFromFriendsCollection);
  }
}