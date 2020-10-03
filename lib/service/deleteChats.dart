import 'package:gupshop/deleteFromFirebase/friendsCollection.dart';
import 'package:gupshop/deleteFromFirebase/deleteMembersFromGroup.dart';

class DeleteChats{

  deleteGroupChat(String documentID, String myNumber, List<dynamic> memberList  ){
    DeleteMembersFromGroup().deleteConversationMetadata(documentID);///conversationMetadata
    FriendsCollection().deleteFromFriendsCollection(myNumber, documentID);///friends collection
    /// delete from the recentChats of all members(memberList, which includes me too)
    /// delete from the friends collection of all members(memberList, which includes me too)
    for(int i=0; i<memberList.length; i++){
      DeleteMembersFromGroup().deleteFromFriendsCollection(memberList[i], documentID);
      DeleteMembersFromGroup().deleteFromRecentChats(memberList[i], documentID);
    }
  }

  deleteIndividualChat(String friendNumber, String documentID ){
    ///for individualChat:
    ///friends collection:
    /// No need to delete from friends collection, as he is still a friend, only
    /// the conversation is deleted, so delete only the recentChats. Do not even
    /// delete from conversationMetadata
    ///recentChats:
    DeleteMembersFromGroup().deleteFromRecentChats(friendNumber, documentID);
  }

}