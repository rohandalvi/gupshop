import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/models/message.dart';

class NewsMessage extends IMessage {
  String newsId;

  NewsMessage({this.newsId,String fromName, String fromNumber, String conversationId, Timestamp timestamp,String messageId}):
        super(fromNumber: fromNumber, fromName: fromName, conversationId: conversationId, timestamp: timestamp, messageId: messageId);


  @override
  Map<String, dynamic> fromJson() {
    return {
      "newsId": newsId,
      "fromName": super.fromName,
      "fromPhoneNumber": super.fromNumber,
      "timeStamp": super.timestamp,
      "conversationId": super.conversationId,
      "messageId": super.messageId,
    };
  }

}
