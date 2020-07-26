import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class PushToSaveCollection{
  String messageType;
  String messageBody;

  PushToSaveCollection({@required this.messageBody, @required this.messageType,});

  save() async{
    DocumentReference dr =  await Firestore.instance.collection("save").add({messageType:messageBody, 'isSaved': false});
    return dr.documentID;
  }

}