import 'package:cloud_firestore/cloud_firestore.dart';

class GetMessageSavedStatusFromFirebase{
  String messageId;

  GetMessageSavedStatusFromFirebase({this.messageId});

  get() async{
    DocumentSnapshot isSavedFuture = await Firestore.instance.collection("save").document(messageId).get();
    return isSavedFuture["isSaved"];
  }
}