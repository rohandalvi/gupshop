import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/PushToFirebase/pushToConversationCollection.dart';
import 'package:gupshop/responsive/textConfig.dart';

class GetFromConversationCollection{
  String conversationId;

  GetFromConversationCollection({this.conversationId});

  CollectionReference path(String conversationId){
    CollectionReference cr = PushToConversationCollection().path(conversationId)
        .collection(TextConfig.messages);
    return cr;
  }

  getTimestamp(String messageId) async{
    Query query = path(conversationId)
        .where(TextConfig.messageId, isEqualTo: messageId);

    QuerySnapshot qc = await query.getDocuments();
    List<DocumentSnapshot> listOfDc = qc.documents;
    Timestamp ts = listOfDc[0].data[TextConfig.timeStampReviews];
    return ts;
  }

  getStartAtDocumentConversationStream(DocumentSnapshot startAtDocument, int limitCounter){
    return path(conversationId)
        .orderBy(TextConfig.timeStampReviews, descending: true).startAtDocument(startAtDocument)
        .limit(limitCounter*10).snapshots();
  }

  getConversationStream(int limitCounter){
    return path(conversationId)
        .orderBy(TextConfig.timeStampReviews, descending: true)
        .limit(limitCounter*10).snapshots();
  }

  getMessagesAsList(int limitCounter) async{
    List<QuerySnapshot> list =  await path(conversationId)
        .orderBy(TextConfig.timeStampReviews, descending: true)
        .limit(limitCounter*10).snapshots().toList();

    return list[0];

  }


  getFirstTenMessages(int limitCounter){
    return path(conversationId)
        .orderBy(TextConfig.timeStampReviews, descending: true)
        .limit(limitCounter*10);
  }
}