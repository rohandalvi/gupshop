import 'package:cloud_firestore/cloud_firestore.dart';

class GetFromMessageReadUnreadCollection{
  String userNumber;
  String conversationId;

  GetFromMessageReadUnreadCollection({this.userNumber, this.conversationId});

  getLatestMessageId() async{
    DocumentSnapshot dc = await Firestore.instance.collection("messageReadUnread")
                          .document(userNumber).get();
    //return dc.data["messageId"];
    return dc.data[conversationId];
  }
}