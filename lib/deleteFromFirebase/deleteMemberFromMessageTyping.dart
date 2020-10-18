import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/PushToFirebase/pushToMessageTypingCollection.dart';
import 'package:gupshop/responsive/textConfig.dart';


/// package -> deleteFromFirebase
class DeleteMemberFromMessageTyping{
  String conversationId;
  String userNumber;

  DeleteMemberFromMessageTyping({this.userNumber, this.conversationId});

  DocumentReference path(String conversationId){
    return PushToMessageTypingCollection().path(conversationId);
  }

  delete() async{
    var val=[];   //blank list for add elements which you want to delete
    val.add(userNumber);
    path(conversationId).updateData({
      TextConfig.members:FieldValue.arrayRemove(val)});
  }
}