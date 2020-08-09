import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/service/message_service.dart';

class ConversationService{

  MessageService messageService = new MessageService();
  String conversationId;
  DocumentSnapshot startBefore = null;
  DocumentSnapshot startAfter = null;
  List<dynamic> list = [];

  StreamController<QuerySnapshot> streamController = new StreamController();

  ConversationService(String conversationId) {
    this.conversationId = conversationId;
    subscribeToLatest();
  }

  StreamSubscription<QuerySnapshot> subscription;

  void setStartAfter(DocumentSnapshot startAfter) {
    this.startAfter = startAfter;

  }

  subscribeToLatest() {

    if(startAfter == null) {
      subscription = Firestore.instance.collection("conversations").document(conversationId).collection("messages").limit(3).orderBy("timeStamp", descending: true).snapshots().listen((event) {
        act(event);
      });
    } else {
      subscription = Firestore.instance.collection("conversations").document(conversationId).collection("messages").orderBy("timeStamp", descending: false).startAfterDocument(startAfter).snapshots().listen((event) {
        act(event);
      });
    }

  }

  void disableActiveSubscription() {
    subscription.cancel();
  }

  void act(QuerySnapshot event) {
    if(event.documents.isNotEmpty) {
      if(startBefore == null) startBefore = event.documents[event.documents.length-1];
      print("Got event ${event.documents[0].data["body"]}");
      startAfter = event.documents[event.documents.length-1];
      print("StartAfter ${startAfter.documentID}");
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
    Firestore.instance.collection("conversations").document(conversationId).collection("messages").startAfterDocument(startBefore).orderBy("timeStamp", descending: true).limit(3).snapshots().listen((event) {
      if(event.documents.isNotEmpty) {
        print("Start before ${startBefore.data["body"]}");
        print("Ev ${event.documents.map((e) => e.data["body"])}");
        startBefore = event.documents[event.documents.length - 1];
        streamController.add(event);
      }
    });
  }

}
