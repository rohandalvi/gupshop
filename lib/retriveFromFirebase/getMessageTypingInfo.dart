import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/PushToFirebase/pushToMessageTypingCollection.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

/// package -> retriveFromFirebase
class GetMessageTypingInfo{
  String conversationId;
  String userNumber;

  GetMessageTypingInfo({this.conversationId, this.userNumber});

  DocumentReference path(String conversationId){
    return PushToMessageTypingCollection().path(conversationId);
  }

//  getTypingStatus() async{
//    String userNumber = await UserDetails().getUserPhoneNoFuture();
//    DocumentSnapshot dc = await path(userNumber).collection(conversationId)
//        .document(TextConfig.typing).get();
//    return dc.data[TextConfig.typing];
//  }


  messageTypingStream() {
    return path(conversationId).snapshots();
  }
}