import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

class PushToConversationCollection{

  DocumentReference path(String conversationId){
    DocumentReference dc = CollectionPaths.conversationsCollectionPath.document(conversationId);
    return dc;
  }

  setBlankData(String conversationId){
    path(conversationId).setData({});
  }

  push(var data) async{
    String conversationId = data[TextConfig.conversationId];
    path(conversationId).collection(TextConfig.messages).add(data);
  }

  pushAndReturnId(var data ) async{
    String conversationId = data[TextConfig.conversationId];
    DocumentReference dr = await path(conversationId).collection(TextConfig.messages).add(data);
    return dr.documentID;
  }
}