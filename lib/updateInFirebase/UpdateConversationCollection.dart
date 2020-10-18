import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/PushToFirebase/pushToConversationCollection.dart';
import 'package:gupshop/responsive/textConfig.dart';

class UpdateConversationCollection{
  final String conversationId;
  final String documentId;
  bool isSaved;

  UpdateConversationCollection({this.conversationId, this.documentId, this.isSaved});

  CollectionReference path(String conversationId){
    CollectionReference cr = PushToConversationCollection().path(conversationId).collection(TextConfig.messages);
    return cr;
  }

  update(){
    path(conversationId).document(documentId).updateData({TextConfig.isSaved: isSaved});
  }

  changeIncreaseDecreaseCountInConversationCollection(String conversationId, String documentId, String changeIn, int changeCount) async{
    await path(conversationId).document(documentId).updateData({changeIn: changeCount});
  }
  
}