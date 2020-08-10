import 'package:gupshop/models/message.dart';

class LocationMessage extends IMessage {
  String text;

  double latitude;

  double longitude;

  LocationMessage({
    this.text,
    this.latitude,
    this.longitude,
    String fromName, String fromNumber, String conversationId, DateTime timestamp,String messageId
  }):
      super(fromNumber: fromNumber, fromName: fromName, conversationId: conversationId, timestamp: timestamp, messageId: messageId);


  @override
  Map<String, dynamic> fromJson() {
    return {
      "body": text,
      "fromName": super.fromName,
      "fromPhoneNumber": super.fromNumber,
      "timeStamp": super.timestamp,
      "conversationId": super.conversationId,
      "latitude": latitude,
      "longitude": longitude,
      "messageId": super.messageId,
    };
  }

}
