import 'package:gupshop/service/getConversationDetails.dart';

/// take listOfFriendNumbers from IndividualChat
/// match them with the friends_userNumber collection to get the names
/// show the names whose names match.
/// When the names dont match, find the names from "users" collection
class GetGroupMemberNames{

  Future<dynamic> findTheNamesOfGroupMembers(String userNumber, List<dynamic> listOfFriendNumbers) async{
    List<dynamic> result = new List();
    result = await helper(userNumber, listOfFriendNumbers);
    return result;
  }

   getGroupMemberNames(String userNumber, List<dynamic> numbers) async {
    List<dynamic> list = new List();
    await Future.wait(numbers.map((element) async{

      String isFriend = await GetConversationDetails().conversationWith(userNumber, element);
      if(isFriend != null) list.add(isFriend);
      else {
        list.add(await GetConversationDetails().getUserNameFromUsersCollection(element));
      }
    }));
    return list;
  }


  Future<List<dynamic>> helper(String userNumber, List<dynamic> listOfFriendNumbers) async {
    return await getGroupMemberNames(userNumber, listOfFriendNumbers);
  }

}