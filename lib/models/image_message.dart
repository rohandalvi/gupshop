import 'package:gupshop/models/message.dart';

class ImageMessage extends IMessage {
  String imageUrl;
  ImageMessage({this.imageUrl, String fromName, String fromNumber, String conversationId, DateTime timestamp, bool isSaved}) :
        super(fromName: fromName, fromNumber: fromNumber, conversationId: conversationId, timestamp: timestamp, isSaved: isSaved);

  @override
  Map<String, dynamic> fromJson() {
    return {
      "imageURL": imageUrl,
      "fromName": super.fromName,
      "fromPhoneNumber": super.fromNumber,
      "timeStamp": super.timestamp,
      "conversationId": super.conversationId,
      "isSaved": super.isSaved,
    };
  }

}
