import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/modules/userDetails.dart';

/// package -> retriveFromFirebase
class GetMessageTypingInfo{
  String conversationId;
  String userNumber;

  GetMessageTypingInfo({this.conversationId, this.userNumber});

  getTypingStatus() async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    DocumentSnapshot dc = await Firestore.instance.collection("messageTyping")
        .document(userNumber).collection(conversationId)
        .document("typing").get();
    return dc.data['typing'];

  }


  messageTypingStream() {
    return Firestore.instance.collection("messageTyping")
        .document(conversationId).snapshots();
  }
}