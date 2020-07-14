import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/service/recentChats.dart';

class SendAndDisplayMessages {

  pushToFirebaseConversatinCollection(Map data) async{
    print("data in pushToFirebaseConversatinCollection: $data");
    String conversationId = data["conversationId"];
    print("conversationId of new forwarded message in SendAndDisplayMessages : $conversationId");
    DocumentReference documentReference = await Firestore.instance.collection("conversations").document(conversationId).collection("messages").add(data);
    print("documentReference of new forwarded message in SendAndDisplayMessages: ${documentReference.documentID}");
    return documentReference;
  }

  changeIncreaseDecreaseCountInConversationCollection(String conversationId, String documentId, String changeIn, int changeCount) async{
    await Firestore.instance.collection("conversations").document(conversationId).collection("messages").document(documentId).setData({changeIn: changeIn}, merge: true);
  }
}
