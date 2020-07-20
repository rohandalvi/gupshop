import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/service/recentChats.dart';

class FirebaseMethods {

  pushToFirebaseConversatinCollection(Map data) async{
    String conversationId = data["conversationId"];
    DocumentReference documentReference = await Firestore.instance.collection("conversations").document(conversationId).collection("messages").add(data);
    return documentReference;
  }

  changeIncreaseDecreaseCountInConversationCollection(String conversationId, String documentId, String changeIn, int changeCount) async{
    await Firestore.instance.collection("conversations").document(conversationId).collection("messages").document(documentId).updateData({changeIn: changeCount});
  }

  pushToNewsCollection(String newsId,String link,int trueBy,int fakeBy,int reportedBy, String customTitle,String customNewsDescription){
    Firestore.instance.collection("news").document(newsId).setData({'link':link,'trueBy':trueBy,'fakeBy':fakeBy,'reportedBy':reportedBy,'customTitle':customTitle,'customNewsDescription':customNewsDescription });
  }

  getNewsDetailsForDisplay(String newsId) async{
    DocumentSnapshot dc = await Firestore.instance.collection("news").document(newsId).get();
    return dc.data;
  }

  changeTrueByFakeByReservedByInNewsCollection(String newsId, String changeInName, int changeInCount){
    Firestore.instance.collection("news").document(newsId).updateData({changeInName : changeInCount});
  }
}
