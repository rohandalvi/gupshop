import 'package:cloud_firestore/cloud_firestore.dart';

class GetConversationIdFromConversationMetadataCollection{
  String userNumber;
  String friendNumber;

  GetConversationIdFromConversationMetadataCollection({this.userNumber, this.friendNumber});
  
  getIndividualChatId() async{
    QuerySnapshot qc = await Firestore.instance.collection("conversationMetadata").where("members", arrayContains: friendNumber).getDocuments();

    for(int i=0; i<qc.documents.length; i++){

      int memberListLength = qc.documents[i]["members"].length;

      if(memberListLength == 2 ){
        if(qc.documents[i]["members"].contains(userNumber))
          {
            print("documentId: ${qc.documents[i].documentID}");
            return qc.documents[i].documentID;
          }
      }
    } return null;
    
  }
  
}