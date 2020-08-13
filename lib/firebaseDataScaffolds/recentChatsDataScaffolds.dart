import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gupshop/models/image_message.dart';
import 'package:gupshop/models/location_message.dart';
import 'package:gupshop/models/text_message.dart';

class RecentChatsDataScaffolds{
  String fromName;
  String fromNumber;
  String conversationId;
  Timestamp timestamp;
  String messageId;
  Position location;

  RecentChatsDataScaffolds({this.fromName, this.fromNumber, this.conversationId, this.timestamp, this.messageId, this.location});

  forImageMessage(){
    Map<String, dynamic> recentChatsData = ImageMessage(fromName:fromName, fromNumber:fromNumber, conversationId:conversationId, timestamp: Timestamp.now(), imageUrl: "📸 Image", messageId: messageId).fromJson();
    return recentChatsData;
  }

  forVideoMessage(){
    Map<String, dynamic> recentChatsData = ImageMessage(fromName:fromName,
        fromNumber:fromNumber, conversationId:conversationId, timestamp: Timestamp.now(),
        imageUrl: "📹 Video", messageId: messageId)
        .fromJson();
    return recentChatsData;
  }

  forLocationMessage(){
    Map<String, dynamic> recentChatsData = LocationMessage(fromName:fromName,
        fromNumber:fromNumber, conversationId:conversationId,
        timestamp:Timestamp.now(),
        text:"📍 Location", latitude:location.latitude,
        longitude:location.longitude,
        messageId: messageId,
    ).fromJson();
    return recentChatsData;
  }

  forNews(){
    Map<String, dynamic> recentChatsData = TextMessage(text: "📰 NEWS",
        fromNumber: fromNumber, fromName: fromName, conversationId: conversationId,
        timestamp: Timestamp.now(), messageId : messageId).fromJson();
    return recentChatsData;
  }

}