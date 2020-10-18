import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/intConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';

class GetFromFriendsCollection{
  String userNumber;
  String friendNumber;

  GetFromFriendsCollection({this.userNumber, this.friendNumber});

  DocumentReference path(){
    DocumentReference cr = CollectionPaths.getFriendsCollectionPath(userPhoneNo: userNumber).document(friendNumber);
    return cr;
  }

  getConversationId() async{
    DocumentSnapshot dc = await path().get();
    if(dc.data == null) return null;
    String conversationId = dc.data[TextConfig.conversationId];
    return conversationId;
  }

  getFriendName() async{
    DocumentSnapshot dc = await path().get();
    String friendName = dc.data[TextConfig.nameList][IntConfig.nameOne];
    return friendName;
  }
}