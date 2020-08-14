import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationMetaData{

  get(String conversationId, String myNumber) async {
    DocumentSnapshot temp = await Firestore.instance.collection(
        "conversationMetadata").document(conversationId).get();
    print("temp.data in conversationMetadata : ${temp.data}");
    return temp.data;
  }
}