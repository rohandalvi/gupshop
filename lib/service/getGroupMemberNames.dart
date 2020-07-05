import 'dart:collection';
import 'package:gupshop/service/getConversationDetails.dart';

/// take listOfFriendNumbers from IndividualChat
/// match them with the friends_userNumber collection to get the names
/// show the names whose names match.
/// When the names dont match, find the names from "users" collection
class GetGroupMemberNames{

  Future<dynamic> getMapOfNameAndNumbers(String userNumber, List<dynamic> listOfFriendNumbers, String userName, String conversationId) async{
    Map<dynamic, String> result = new SplayTreeMap();/// for storing names in alphabetical order
    result = await helper(userNumber, listOfFriendNumbers, userName, conversationId);
    return result;
  }


   getMemberNameNumbers(String userNumber, List<dynamic> numbers, String userName, String conversationId) async {
    Map<dynamic, String> map = new SplayTreeMap();/// for storing names in alphabetical order
    map[userName] = userNumber; /// adding username and number to map
    /// adding admin name and number to user it in ShowGroupMembers()._showGroupMemberNames() to show the name of admin
    map['admin'] = await GetConversationDetails().knowWhoIsAdmin(conversationId);

    await Future.wait(numbers.map((element) async{

      String isFriend = await GetConversationDetails().conversationWith(userNumber, element);
      print("isFriend: $isFriend");
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