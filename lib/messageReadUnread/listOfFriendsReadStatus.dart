import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/messageReadUnread/messageReadUnreadData.dart';

class ListOfFriendStatusReadStatus{
  List<dynamic> listOfFriends;
  String conversationId;
  Timestamp conversationsLatestMessageTimestamp;

  ListOfFriendStatusReadStatus({this.listOfFriends, this.conversationId, this.conversationsLatestMessageTimestamp});

  readStatus() async{
    print("listOfFriendsNumbers in ListOfFriendStatusReadStatus: $listOfFriends");
    for(int i =0; i<listOfFriends.length; i++){
      int comparison = await (
          MessageReadUnreadData(
            number: listOfFriends[i],
            conversationId: conversationId,
            conversationsLatestMessageTimestamp: conversationsLatestMessageTimestamp,
          ).timestampDifference());
      print("comparison  in readStatus : $comparison");

      if(comparison < 0) return false;
    } return true;

  }

}