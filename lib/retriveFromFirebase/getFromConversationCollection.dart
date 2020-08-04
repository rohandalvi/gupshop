import 'package:cloud_firestore/cloud_firestore.dart';

class GetFromConversationCollection{
  String conversationId;

  GetFromConversationCollection({this.conversationId});

  getTimestamp(String messageId) async{
    Query query = Firestore.instance
        .collection("conversations").document(conversationId)
        .collection("messages")
        .where("messageId", isEqualTo: messageId);

    QuerySnapshot qc = await query.getDocuments();
    List<DocumentSnapshot> listOfDc = qc.documents;
    Timestamp ts = listOfDc[0].data["timeStamp"];
    return ts;
  }

}