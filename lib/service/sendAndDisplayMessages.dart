import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/service/recentChats.dart';

class SendAndDisplayMessages {

  pushToFirebaseConversatinCollection(Map data, ){
    String conversationId = data["conversationId"];
    Firestore.instance.collection("conversations").document(conversationId).collection("messages").add(data);
  }
}
