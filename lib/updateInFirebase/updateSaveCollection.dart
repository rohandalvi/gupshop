import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateSaveCollection{
  String messageId;
  bool isSaved;

  UpdateSaveCollection({this.messageId, this.isSaved});


  updateIsSaved(){
    Firestore.instance.collection("save").document(messageId).updateData({'isSaved': isSaved});
  }
}