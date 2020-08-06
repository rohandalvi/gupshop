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

  getStartAtDocumentConversationStream(DocumentSnapshot startAtDocument, int limitCounter){
    print("in getStartAtDocumentConversationStream");
    return Firestore.instance.collection("conversations")
        .document(conversationId).collection("messages")
        .orderBy("timeStamp", descending: true).startAtDocument(startAtDocument)
        .limit(limitCounter*10).snapshots();
  }

  getConversationStream(int limitCounter){
    print("in getConversationStream");
    return Firestore.instance.collection("conversations")
        .document(conversationId).collection("messages")
        .orderBy("timeStamp", descending: true)
        .limit(limitCounter*10).snapshots();
  }

  getMessagesAsList(int limitCounter) async{
    print("stream: ${Firestore.instance.collection("conversations")
        .document(conversationId).collection("messages")
        .orderBy("timeStamp", descending: true)
        .limit(limitCounter*10).snapshots().toList()}");


    List<QuerySnapshot> list =  await Firestore.instance.collection("conversations")
        .document(conversationId).collection("messages")
        .orderBy("timeStamp", descending: true)
        .limit(limitCounter*10).snapshots().toList();

    return list[0];

  }


  getFirstTenMessages(int limitCounter){
    return Firestore.instance.collection("conversations")
        .document(conversationId).collection("messages")
        .orderBy("timeStamp", descending: true)
        .limit(limitCounter*10);
  }
}