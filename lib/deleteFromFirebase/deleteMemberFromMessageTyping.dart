import 'package:cloud_firestore/cloud_firestore.dart';


/// package -> deleteFromFirebase
class DeleteMemberFromMessageTyping{
  String conversationId;
  String userNumber;

  DeleteMemberFromMessageTyping({this.userNumber, this.conversationId});

  delete() async{
    var val=[];   //blank list for add elements which you want to delete
    val.add(userNumber);
    Firestore.instance.collection("messageTyping").document(conversationId).updateData({
      "members":FieldValue.arrayRemove(val)});
  }
}