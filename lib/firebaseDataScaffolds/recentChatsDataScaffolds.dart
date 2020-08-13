import 'package:gupshop/models/image_message.dart';

class RecentChatsDataScaffolds{
  String fromName;
  String fromNumber;
  String conversationId;
  DateTime timestamp;
  String messageId;

  RecentChatsDataScaffolds({this.fromName, this.fromNumber, this.conversationId, this.timestamp, this.messageId});

  forImageMessage(){
    Map<String, dynamic> recentChatsData = ImageMessage(fromName:fromName, fromNumber:fromNumber, conversationId:conversationId, timestamp: DateTime.now(), imageUrl: "📸 Image", messageId: messageId).fromJson();
    return recentChatsData;
  }

  forVideoMessage(){
    Map<String, dynamic> recentChatsData = ImageMessage(fromName:fromName, fromNumber:fromNumber, conversationId:conversationId, timestamp: DateTime.now(), imageUrl: "📹 Video", messageId: messageId).fromJson();
    return recentChatsData;
  }

}