import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/PushToFirebase/friendsCollection.dart' as pushToFriendsCollection;
import 'deleteMembersFromGroup.dart';

class FriendsCollection{

  /// as example in import
  CollectionReference path(String friendNumber){
    CollectionReference c =  pushToFriendsCollection.FriendsCollection(userPhoneNo: friendNumber).path();
    return c;
  }

  deleteFromFriendsCollection(String friendNumber, String documentID){
    DocumentReference deleteFriendFromFriendsCollection = path(friendNumber).document(documentID);
    DeleteMembersFromGroup().deleteDocumentFromSnapshot(deleteFriendFromFriendsCollection);
  }
}