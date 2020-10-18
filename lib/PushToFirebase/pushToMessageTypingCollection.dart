import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

class PushToMessageTypingCollection{
  String conversationId;
  String userNumber;

  PushToMessageTypingCollection({this.conversationId, this.userNumber});

  DocumentReference path(String conversationId){
    DocumentReference dc = CollectionPaths.messageTypingCollectionPath.document(conversationId);
    return dc;
  }

  pushTypingStatus(){
//    Firestore.instance.collection("messageTyping").document(userNumber)
//        .setData({}, merge: true);
  List<String> members = new List();
  members.add(userNumber);

    path(conversationId).setData({TextConfig.members: members}, merge: true);
  }
}