import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/PushToFirebase/pushToConversationCollection.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/service/recentChats.dart';

class FirebaseMethods {

//  pushToConversatinCollection(Map data) async{
//    PushToConversationCollection().push(data);
//
//    String conversationId = data["conversationId"];
//    DocumentReference documentReference = await Firestore.instance.collection("conversations").document(conversationId).collection("messages").add(data);
//    return documentReference;
//  }

//  changeIncreaseDecreaseCountInConversationCollection(String conversationId, String documentId, String changeIn, int changeCount) async{
//    await Firestore.instance.collection("conversations").document(conversationId).collection("messages").document(documentId).updateData({changeIn: changeCount});
//  }

//  pushToNewsCollection(String newsId,String link,int trueBy,int fakeBy,int reportedBy, String customTitle,String customNewsDescription){
//    Firestore.instance.collection("news").document(newsId).setData({'link':link,'trueBy':trueBy,'fakeBy':fakeBy,'reportedBy':reportedBy,'customTitle':customTitle,'customNewsDescription':customNewsDescription });
//  }

//  getNewsDetailsForDisplay(String newsId) async{
//    DocumentSnapshot dc = await Firestore.instance.collection("news").document(newsId).get();
//    return dc.data;
//  }

//  updateVoteCountToNewsCollection(String newsId, String changeInName, int changeInCount){
//    print("newsId: $newsId");
//    print("changeInName: $changeInName");
//    print("changeInCount : $changeInCount");
//    Firestore.instance.collection("news").document(newsId).updateData({changeInName : changeInCount});
//  }

  getVoteTrueOrFalse(String newsId, String category) async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    DocumentSnapshot dc = await Firestore.instance.collection("newsStatistics").document(newsId).collection(category).document(userNumber).get();
    return dc.data['voteStatus'];
  }

  getVoteStatus(String newsId, String category) async{
    return await FirebaseMethods().getVoteTrueOrFalse(newsId, category);
  }

  updateVoteStatusToNewsStatistics(String newsId, String category, bool updatedVoteStatus) async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    await Firestore.instance.collection("newsStatistics").document(newsId).collection(category).document(userNumber).updateData({'voteStatus': updatedVoteStatus});
  }

  getHasCreatedOrForwardedTheNews(String newsId, String category) async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    DocumentSnapshot dc = await Firestore.instance.collection("newsStatistics").document(newsId).collection(category).document(userNumber).get();
    return dc.data['isOwner'];
  }
}
