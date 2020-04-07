import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/service/message_service.dart';

class ConversationService{

  MessageService messageService = new MessageService();
  List<Future> expandConversation(String conversationId) {

    var completer = new Completer();
    Firestore.instance.collection("conversations").document(conversationId).get().then((documentSnapshot) async {

      var that = this;
      print("Document Snapshot ${documentSnapshot.data["messageId"]}");
      //messageService.getMessages(messageIds)
      var messageIds = documentSnapshot.data["messageId"];
      await Future.wait(messageService.getMessages(messageIds)).then((value){

        completer.complete(that);
      });





    });

  }
}
