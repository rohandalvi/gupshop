import 'package:gupshop/models/image_message.dart';

class RecentChatsDataScaffolds{
  String fromName;
  String fromNumber;
  String conversationId;
  DateTime timestamp;

  RecentChatsDataScaffolds({this.fromName, this.fromNumber, this.conversationId, this.timestamp});

  forImageMessage(){
    Map<String, dynamic> recentChatsData = ImageMessage(fromName:fromName, fromNumber:fromNumber, conversationId:conversationId, timestamp: DateTime.now(), imageUrl: "📸 Image").fromJson();
    return recentChatsData;
  }

  forVideoMessage(){
    Map<String, dynamic> recentChatsData = ImageMessage(fromName:fromName, fromNumber:fromNumber, conversationId:conversationId, timestamp: DateTime.now(), imageUrl: "📹 Video").fromJson();
    return recentChatsData;
  }

}