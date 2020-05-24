import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class RecentChats{
  String userNumber;
  String convId;
  String friendName;
  RecentChats({@required this.userNumber, this.convId, this.friendName});

  pushToRecentChatsCollectionFirebasse() async{
    Firestore.instance.collectionGroup("messages").orderBy("timeStamp", descending: true).limit(1).snapshots().listen((data){
      data.documentChanges.forEach((change){
        print("newMessage: ${change.document.data["body"]}");
        var newMessage= change.document.data;
        Firestore.instance.collection("recentChats").document(userNumber).collection("conversations").document(convId).setData({"message": newMessage, "name": friendName});
      });
    });
  }
}
