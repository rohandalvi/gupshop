import 'package:gupshop/models/message.dart';

class VideoMessage extends IMessage{
  String videoURL;

  VideoMessage({
    this.videoURL,
    String fromName, String fromNumber, String conversationId, DateTime timestamp,
  }):super(fromName: fromName, fromNumber: fromNumber, conversationId: conversationId, timestamp: timestamp);

  @override
  Map<String, dynamic> fromJson() {
    return {
      "videoURL": videoURL,
      "fromName": super.fromName,
      "fromPhoneNumber": super.fromNumber,
      "timeStamp": super.timestamp,
      "conversationId": super.conversationId
    };
  }

}