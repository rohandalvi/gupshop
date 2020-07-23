import 'package:gupshop/PushToFirebase/toConversationCollection.dart';
import 'package:gupshop/PushToFirebase/toRecentChatsCollection.dart';

class PushMessagesToConversationAndRecentChatsCollection{
  String conversationId;
  var conversationCollectionData;
  var recentChatsData;
  String userName;
  String userPhoneNo;
  List<dynamic>listOfFriendNumbers;
  bool groupExits;

  PushMessagesToConversationAndRecentChatsCollection({
    this.conversationId,
    this.conversationCollectionData,
    this.recentChatsData,
    this.userName,
    this.userPhoneNo,
    this.listOfFriendNumbers,
    this.groupExits,
  });


  push(){
    print("in PushMessagesToConversationAndRecentChatsCollection");
    ToConversationCollection().push(conversationId, conversationCollectionData);
    ToRecentChatsCollection().push(recentChatsData, conversationId, userPhoneNo, userName, listOfFriendNumbers, groupExits);
  }
}