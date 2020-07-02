import 'package:flutter/material.dart';
import 'package:gupshop/service/getConversationDetails.dart';

/// take listOfFriendNumbers from IndividualChat
/// match them with the friends_userNumber collection to get the names
/// show the names whose names match.
/// When the names dont match, find the names from "users" collection
class GetGroupMemberNames{

  Future<dynamic> getMapOfNameAndNumbers(String userNumber, List<dynamic> listOfFriendNumbers) async{
    Map<dynamic, String> result = new Map();
    result = await helper(userNumber, listOfFriendNumbers);
    return result;
  }


   getMemberNameNumbers(String userNumber, List<dynamic> numbers) async {
    print("numberlist : $numbers");
    Map<dynamic, String> map = new Map();
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


  Future<Map<dynamic, String>> helper(String userNumber, List<dynamic> listOfFriendNumbers) async {
    return await getMemberNameNumbers(userNumber, listOfFriendNumbers);
  }

}