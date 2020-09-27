import 'package:gupshop/PushToFirebase/pushToConversationCollection.dart';
import 'package:gupshop/PushToFirebase/recentChatsCollection.dart';

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
    PushToConversationCollection().push(conversationCollectionData);
    RecentChatsCollection().push(recentChatsData, conversationId, userPhoneNo, userName, listOfFriendNumbers, groupExits);
  }
}