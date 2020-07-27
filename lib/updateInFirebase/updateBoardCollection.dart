import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateBoardCollection{
  String userNumber;
  String boardName;
  String messageId;
  bool isSaved;
  String body;

  UpdateBoardCollection({this.userNumber, this.boardName, this.messageId, this.isSaved, this.body});

  update(){
    Firestore.instance.collection("savedMessageBoards").document(userNumber).collection(boardName).document(messageId).updateData({'isSaved': isSaved, 'body': body});
  }

}