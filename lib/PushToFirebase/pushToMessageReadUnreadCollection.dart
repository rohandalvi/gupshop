import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';

class PushToMessageReadUnreadCollection{
  String userNumber;
  String messageId;
  String conversationId;

  PushToMessageReadUnreadCollection({this.userNumber, this.messageId, this.conversationId});

  DocumentReference path(String userNumber){
    DocumentReference dc = CollectionPaths.messageReadUnreadCollectionPath.document(userNumber);
    return dc;
  }

  pushLatestMessageId(){
    path(userNumber).setData({conversationId : messageId}, merge: true);
  }

  setBlankDocument(){
    path(userNumber).setData({}, merge: true);
  }

}