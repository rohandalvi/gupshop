import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/PushToFirebase/recentChatsCollection.dart';
import 'package:gupshop/responsive/textConfig.dart';

class RecentChats{

  DocumentReference path({String userNumber}){
   return RecentChatsCollection().path(userNumber);
  }


  orderedStream({String userNumber}){
    return path(userNumber: userNumber).collection(TextConfig.conversationsRecentChats).orderBy(TextConfig.timeStamp, descending: true).snapshots();
  }
}