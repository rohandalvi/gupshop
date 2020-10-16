import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

class NewsCollection{

  DocumentReference path(String newsId){
    DocumentReference dc = CollectionPaths.newsCollectionPath.document(newsId);
    return dc;
  }

  push(String newsId,String link,int trueBy,int fakeBy,int reportedBy, String customTitle,String customNewsDescription){
    path(newsId).setData({TextConfig.link:link,TextConfig.trueBy:trueBy,TextConfig.fakeBy:fakeBy,
      TextConfig.reportedBy:reportedBy, TextConfig.customTitle:customTitle,
      TextConfig.customNewsDescription:customNewsDescription });
  }

  getNewsDetailsForDisplay(String newsId) async{
    DocumentSnapshot dc = await path(newsId).get();
    return dc.data;
  }

  updateVoteCountToNewsCollection(String newsId, String changeInName, int changeInCount){
    path(newsId).updateData({changeInName : changeInCount});
  }



}