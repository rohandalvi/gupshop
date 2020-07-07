import 'package:flutter/cupertino.dart';
import 'package:gupshop/service/addToFriendsCollection.dart';
import 'package:gupshop/service/recentChats.dart';

class ChangeGroupName extends StatefulBuilder{
  changeName(List<String> listOfNumbersInAGroup, String id, String newGroupName){
    print("in changeName");
    /// change group name in friends collection of all group members
    /// change group name in recentChats collection of all group members

    for(int i=0; i<listOfNumbersInAGroup.length; i++){
      String friendNumber = listOfNumbersInAGroup[i];
      AddToFriendsCollection(friendListForGroupForFriendsCollection: listOfNumbersInAGroup).updateGroupNameInFriendsCollection(friendNumber, id, newGroupName);
      RecentChats().updateGroupName(friendNumber, id, newGroupName);
    }
  }
}
