
abstract class IMessage {

  String fromName, fromNumber, conversationId;
  DateTime timestamp;
  bool isSaved;

  IMessage({
    this.fromName,
    this.fromNumber ,
    this.conversationId ,
    this.timestamp,
    this.isSaved,
});

  Map<String, dynamic> fromJson();

  String getFromName() {
    return fromName;
  }

  String getFromNumber() {
    return fromNumber;
  }



}