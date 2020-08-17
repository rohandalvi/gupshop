import 'package:cloud_firestore/cloud_firestore.dart';

class GetFromFriendsCollection{
  String userNumber;
  String friendNumber;

  GetFromFriendsCollection({this.userNumber, this.friendNumber});

  getConversationId() async{
    DocumentSnapshot dc = await Firestore.instance.collection("friends_$userNumber").document(friendNumber).get();
    if(dc.data == null) return null;
    String conversationId = dc.data["conversationId"];
    return conversationId;
  }
}