import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

class NewsStatisticsCollection{

  DocumentReference path(String newsMessageId){
    DocumentReference dc = CollectionPaths.newsStatisticsCollectionPath.document(newsMessageId);
    return dc;
  }


  CollectionReference subCollectionPath(String newsMessageId, String subCollectionName){
    CollectionReference dc = CollectionPaths.newsStatisticsCollectionPath.document(newsMessageId).collection(subCollectionName);
    return dc;
  }

  checkIfUserExistsInSubCollection(String newsMessageId,String userNumber,String subCollectionName) async{
    DocumentSnapshot dc = await subCollectionPath(newsMessageId, subCollectionName).document(userNumber).get();
    var documentDoesntExists = dc.data;

    if(documentDoesntExists == null) {
      await setDocument(newsMessageId, userNumber);
      return false;/// then add the document using addToSet()
    }
    return true;
  }


  checkIfUserExistsAndAddToSet(String newsMessageId, String userNumber, String userName, String subCollectionName, bool votingStatus) async{
    if(subCollectionName == TextConfig.trueBy){
      if(await checkIfUserExistsInSubCollection(newsMessageId, userNumber, subCollectionName) == false){
        subCollectionPath(newsMessageId, subCollectionName).document(userNumber).setData({TextConfig.name: userName,
          TextConfig.number: userNumber, TextConfig.voteStatus:votingStatus, TextConfig.isOwner: true});
        return false;
      }return true;
    }else{
      if(await checkIfUserExistsInSubCollection(newsMessageId, userNumber, subCollectionName) == false){
        subCollectionPath(newsMessageId, subCollectionName).document(userNumber).setData({TextConfig.name: userName, TextConfig.number: userNumber,
          TextConfig.voteStatus:votingStatus,});
        return false;
      }return true;
    }
  }

  addToSet(String newsMessageId, String userNumber, String userName, String subCollectionName, bool votingStatus) async{
    subCollectionPath(newsMessageId, subCollectionName).document(userNumber).setData({TextConfig.name: userName, TextConfig.number: userNumber,
      TextConfig.voteStatus:votingStatus,});
  }

  setDocument(String newsMessageId, String userNumber,) async{
    await path(newsMessageId).setData({});
  }


  getVoteTrueOrFalse(String newsMessageId, String category) async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    DocumentSnapshot dc = await path(newsMessageId).collection(category).document(userNumber).get();
    return dc.data[TextConfig.voteStatus];
  }


  updateVoteStatusToNewsStatistics(String newsMessageId, String category, bool updatedVoteStatus) async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    await path(newsMessageId).collection(category).document(userNumber).updateData({TextConfig.voteStatus: updatedVoteStatus});
  }

  getHasCreatedOrForwardedTheNews(String newsMessageId, String category) async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    DocumentSnapshot dc = await path(newsMessageId).collection(category).document(userNumber).get();
    return dc.data[TextConfig.isOwner];
  }
}