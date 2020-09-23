import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationMetaData{
  String conversationId;
  String myNumber;

  ConversationMetaData({this.myNumber, this.conversationId});

  get(String conversationId, String myNumber) async {
    DocumentSnapshot temp = await Firestore.instance.collection(
        "conversationMetadata").document(conversationId).get();
    return temp.data;
  }

  Future<String> getAdminNumber() async{
    DocumentSnapshot temp = await Firestore.instance.collection(
        "conversationMetadata").document(conversationId).get();

    String adminNumber = temp.data["admin"];
    return adminNumber;
  }
}