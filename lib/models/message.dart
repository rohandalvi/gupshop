
abstract class IMessage {

  String fromName, fromNumber, conversationId;
  DateTime timestamp;

  IMessage({
  this.fromName,
  this.fromNumber ,
  this.conversationId ,
  this.timestamp
});

  Map<String, dynamic> fromJson();

  String getFromName() {
    return fromName;
  }

  String getFromNumber() {
    return fromNumber;
  }



}