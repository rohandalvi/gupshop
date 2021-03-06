import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/PushToFirebase/pushToMessageTypingCollection.dart';
import 'package:gupshop/responsive/textConfig.dart';

class UpdateTyping{
  String conversationId;
  String userNumber;

  UpdateTyping({this.conversationId, this.userNumber});

  DocumentReference path(String conversationId){
    return PushToMessageTypingCollection().path(conversationId);
  }

  update(){
    List<String> members = new List();
    members.add(userNumber);
    path(conversationId).updateData({
      TextConfig.members: FieldValue.arrayUnion(members)
    });
  }
}