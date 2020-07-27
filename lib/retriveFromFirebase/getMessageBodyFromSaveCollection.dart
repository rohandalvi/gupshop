import 'package:cloud_firestore/cloud_firestore.dart';

class GetMessageBodyFromSaveCollection{
  String messageId;

  GetMessageBodyFromSaveCollection({this.messageId});

  getBody() async{
    DocumentSnapshot bodyFuture = await Firestore.instance.collection("save").document(messageId).get();
    return bodyFuture["body"];
  }

}