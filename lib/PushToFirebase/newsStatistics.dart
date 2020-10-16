import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

class NewsStatistics{

  DocumentReference path(String newsId){
    DocumentReference dc = CollectionPaths.newsCollectionPath.document(newsId);
    return dc;
  }

  getVoteTrueOrFalse(String newsId, String category) async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    DocumentSnapshot dc = await Firestore.instance.collection("newsStatistics").document(newsId).collection(category).document(userNumber).get();
    return dc.data['voteStatus'];
  }

//  getVoteStatus(String newsId, String category) async{
//    return await FirebaseMethods().getVoteTrueOrFalse(newsId, category);
//  }

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