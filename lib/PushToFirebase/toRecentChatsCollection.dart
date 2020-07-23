import 'package:gupshop/service/recentChats.dart';

class ToRecentChatsCollection{
  push(Map<String, dynamic> message, String conversationId, String userPhoneNo, String userName, List<dynamic> listOfFriendNumbers, bool groupExits){
    print("in ToRecentChatsCollection");
   RecentChats(message: message, convId: conversationId, userNumber:userPhoneNo, userName:userName , listOfOtherNumbers:listOfFriendNumbers, groupExists:groupExits).getAllNumbersOfAConversation();
  }
}