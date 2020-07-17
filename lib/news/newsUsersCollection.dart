import 'package:cloud_firestore/cloud_firestore.dart';

class NewsUsersCollection{
  checkIfUserExists(String newsMessageId,String userNumber,) async{
    QuerySnapshot value = await Firestore.instance.collection("newsUsers").document(newsMessageId).collection(userNumber).where('number', isEqualTo: userNumber).getDocuments();
    bool documentDoesntExists = value.documents.isEmpty;

    if(documentDoesntExists == true) {
      await setDocument(newsMessageId, userNumber);
      return false;/// then add the document using addToSet()
    }
    return true;
  }

  addToSet(String newsMessageId, String userNumber, String userName) async{
    if(await checkIfUserExists(newsMessageId, userNumber) == false){
      Firestore.instance.collection("newsUsers").document(newsMessageId).collection(userNumber).add({'name': userName, 'number': userNumber});
      return false;
    }return true;
  }

  setDocument(String newsMessageId, String userNumber) async{
    await Firestore.instance.collection("newsUsers").document(newsMessageId).setData({});
  }
}