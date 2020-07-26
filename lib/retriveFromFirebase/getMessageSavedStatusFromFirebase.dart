import 'package:cloud_firestore/cloud_firestore.dart';

class GetMessageSavedStatusFromFirebase{
  String messageId;
  String userNumber;
  String boardName;

  GetMessageSavedStatusFromFirebase({this.messageId, this.boardName, this.userNumber});

  get() async{
    DocumentSnapshot isSavedFuture = await Firestore.instance.collection("save").document(userNumber).collection(boardName).document(messageId).get();
    return isSavedFuture["isSaved"];
  }
}