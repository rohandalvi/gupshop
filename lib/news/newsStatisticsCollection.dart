import 'package:cloud_firestore/cloud_firestore.dart';

class NewsStatisticsCollection{
//  checkIfUserExists(String newsMessageId,String userNumber,) async{
//    QuerySnapshot value = await Firestore.instance.collection("newsUsers").document(newsMessageId).collection(userNumber).where('number', isEqualTo: userNumber).getDocuments();
//    bool documentDoesntExists = value.documents.isEmpty;
//
//    if(documentDoesntExists == true) {
//      await setDocument(newsMessageId, userNumber);
//      return false;/// then add the document using addToSet()
//    }
//    return true;
//  }
//
//  addToSet(String newsMessageId, String userNumber, String userName) async{
//    if(await checkIfUserExists(newsMessageId, userNumber) == false){
//      Firestore.instance.collection("newsUsers").document(newsMessageId).collection(userNumber).add({'name': userName, 'number': userNumber});
//      return false;
//    }return true;
//  }
//
//  setDocument(String newsMessageId, String userNumber) async{
//    await Firestore.instance.collection("newsUsers").document(newsMessageId).setData({});
//  }

  checkIfUserExistsInSubCollection(String newsMessageId,String userNumber,String subCollectionName) async{
    DocumentSnapshot dc = await Firestore.instance.collection("newsStatistics").document(newsMessageId).collection(subCollectionName).document(userNumber).get();
    print("documentDoesntExists: ${dc.data}");
    var documentDoesntExists = dc.data;

    if(documentDoesntExists == null) {
      await setDocument(newsMessageId, userNumber);
      return false;/// then add the document using addToSet()
    }
    return true;
  }


  addToSet(String newsMessageId, String userNumber, String userName, String subCollectionName, bool votingStatus) async{
    if(await checkIfUserExistsInSubCollection(newsMessageId, userNumber, subCollectionName) == false){
      Firestore.instance.collection("newsStatistics").document(newsMessageId).collection(subCollectionName).document(userNumber).setData({'name': userName, 'number': userNumber, 'voteStatus':votingStatus});
      return false;
    }return true;
  }

  setDocument(String newsMessageId, String userNumber,) async{
    await Firestore.instance.collection("newsStatistics").document(newsMessageId).setData({});
  }
}