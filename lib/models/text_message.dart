import 'package:gupshop/models/message.dart';

class TextMessage extends IMessage {
  String text;

  TextMessage({this.text,String fromName, String fromNumber, String conversationId, DateTime timestamp,}):
        super(fromNumber: fromNumber, fromName: fromName, conversationId: conversationId, timestamp: timestamp);


  @override
  Map<String, dynamic> fromJson() {
    return {
      "body": text,
      "fromName": super.fromName,
      "fromPhoneNumber": super.fromNumber,
      "timeStamp": super.timestamp,
      "conversationId": super.conversationId
    };
  }

}
