import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/service/getConversationDetails.dart';

/// take listOfFriendNumbers from IndividualChat
/// match them with the friends_userNumber collection to get the names
/// show the names whose names match.
/// When the names dont match, find the names from "users" collection
class GetGroupMemberNames{

  Future<dynamic> getMapOfNameAndNumbers(String userNumber, List<dynamic> listOfFriendNumbers, String userName, String conversationId) async{
    print("listOfFriendNumbers: $listOfFriendNumbers");
    Map<dynamic, String> result = new Map();
    result = await helper(userNumber, listOfFriendNumbers, userName, conversationId);
    return result;
  }


   getMemberNameNumbers(String userNumber, List<dynamic> numbers, String userName, String conversationId) async {
    Map<dynamic, String> map = new Map();
    map[userName] = userNumber;
    map['admin'] = await GetConversationDetails().knowWhoIsAdmin(conversationId);

    await Future.wait(numbers.map((element) async{

      String isFriend = await GetConversationDetails().conversationWith(userNumber, element);
      if(isFriend != null) map[isFriend] =element;
      else {
        map[await GetConversationDetails().getUserNameFromUsersCollection(element)] = element;
      }
    }));
    print("map: $map");
    return map;
  }


  Future<Map<dynamic, String>> helper(String userNumber, List<dynamic> listOfFriendNumbers, String userName, String conversationId) async {
    return await getMemberNameNumbers(userNumber, listOfFriendNumbers, userName, conversationId);
  }


}