import 'package:gupshop/models/message.dart';

class ImageMessage extends IMessage {

  @override
  String conversationId;

  @override
  String fromName;

  @override
  String fromNumber;

  @override
  DateTime timestamp;

  String text;

  ImageMessage(String fromName, String fromNumber, String conversationId, DateTime timestamp, String text) :
        this.text = text,
        super(fromName: fromName, fromNumber: fromNumber, conversationId: conversationId, timestamp: timestamp);



  @override
  Map<String, dynamic> fromJson() {
    return {
      "body": text,
      "fromName": fromName,
      "fromPhoneNumber": fromNumber,
      "timeStamp": DateTime.now(),
      "conversationId": conversationId
    };
  }

}
