import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/service/message_service.dart';

class ConversationService{

  static final int INITIAL_MESSAGE_COUNT = 10;
  static final int PAGINATION_LIMIT = 10;
  MessageService messageService = new MessageService();
  String conversationId;
  DocumentSnapshot startBefore = null;
  DocumentSnapshot startAfter = null;
  List<dynamic> list = [];
  bool validStream;

  StreamController<QuerySnapshot> streamController = new StreamController();

  ConversationService(String conversationId) {
    if(validStream != false){
      validStream = true;
    }
    this.conversationId = conversationId;
    subscribeToLatest();
  }

  StreamSubscription<QuerySnapshot> subscription;

  void setStartAfter(DocumentSnapshot startAfter) {
    this.startAfter = startAfter;

  }

  subscribeToLatest() {

    if(startAfter == null) {

      subscription = Firestore.instance.collection("conversations").document(conversationId).collection("messages").limit(INITIAL_MESSAGE_COUNT).orderBy("timeStamp", descending: true).snapshots().listen((event) {
        act(event);
      });
    } else {
      subscription = Firestore.instance.collection("conversations").document(conversationId).collection("messages").orderBy("timeStamp", descending: false).startAfterDocument(startAfter).snapshots().listen((event) {
        act(event);
      });
    }

  }

  bool isValidStream(){
    return validStream;
  }

  disableActiveSubscription()  async {
    validStream = false;
    await subscription.cancel();
    await streamController.close();

  }

  void act(QuerySnapshot event) {
    if(event.documents.isNotEmpty) {
      if(startBefore == null) startBefore = event.documents[event.documents.length-1];
      startAfter = event.documents[0];
      streamController.add(event);
      change();
    }
  }

  change() {
    subscription.cancel();
    subscribeToLatest();
  }

  Stream<QuerySnapshot> getStream() {
    return streamController.stream;
  }


  void paginate() {
    Firestore.instance.collection("conversations").document(conversationId).collection("messages")
        .startAfterDocument(startBefore).orderBy("timeStamp", descending: true).limit(PAGINATION_LIMIT).snapshots().listen((event) {
      if(event.documents.isNotEmpty) {
        startBefore = event.documents[event.documents.length - 1];
        streamController.add(event);
      }
    });
  }

}
