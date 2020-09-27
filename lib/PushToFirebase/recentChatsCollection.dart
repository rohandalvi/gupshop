import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/service/recentChats.dart';

class RecentChatsCollection{
  String userPhoneNo;

  RecentChatsCollection({this.userPhoneNo});

  DocumentReference path(){
    DocumentReference dc = CollectionPaths.recentChatsCollectionPath.document(userPhoneNo);
    return dc;
  }

  push(Map<String, dynamic> message, String conversationId, String userPhoneNo, String userName, List<dynamic> listOfFriendNumbers, bool groupExits){
    print("in ToRecentChatsCollection");
   RecentChats(message: message, convId: conversationId, userNumber:userPhoneNo, userName:userName , listOfOtherNumbers:listOfFriendNumbers, groupExists:groupExits).getAllNumbersOfAConversation();
  }


  setBlankData(){
    DocumentReference dc = path();
    return path().setData({});
  }
}