
abstract class IMessage {

  String fromName, fromNumber, conversationId;
  DateTime timestamp;
  String messageId;

  IMessage({
    this.fromName,
    this.fromNumber ,
    this.conversationId ,
    this.timestamp,
    this.messageId,
});

  Map<String, dynamic> fromJson();

  String getFromName() {
    return fromName;
  }

  String getFromNumber() {
    return fromNumber;
  }



}