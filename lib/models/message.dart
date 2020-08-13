
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IMessage {

  String fromName, fromNumber, conversationId;
  Timestamp timestamp;
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