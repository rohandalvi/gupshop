import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/models/message.dart';

class ImageMessage extends IMessage {
  String imageUrl;
  ImageMessage({this.imageUrl, String fromName, String fromNumber, String conversationId, Timestamp timestamp, bool isSaved, String messageId}) :
        super(fromName: fromName, fromNumber: fromNumber, conversationId: conversationId, timestamp: timestamp, messageId: messageId);

  @override
  Map<String, dynamic> fromJson() {
    return {
      "imageURL": imageUrl,
      "fromName": super.fromName,
      "fromPhoneNumber": super.fromNumber,
      "timeStamp": super.timestamp,
      "conversationId": super.conversationId,
      "messageId": super.messageId,
    };
  }

}
