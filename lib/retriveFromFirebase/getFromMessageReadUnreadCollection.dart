import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/PushToFirebase/pushToMessageReadUnreadCollection.dart';
import 'package:gupshop/responsive/textConfig.dart';

class GetFromMessageReadUnreadCollection{
  String userNumber;
  String conversationId;

  GetFromMessageReadUnreadCollection({this.userNumber, this.conversationId});

  DocumentReference path(){
    return PushToMessageReadUnreadCollection().path(userNumber);
  }

  getLatestMessageId() async{
    DocumentSnapshot dc = await path().get();
    return dc.data[conversationId];
  }

  getLatestMessageIdStream(){
    return path().snapshots();
  }

  containsMessageId(String messageId) async{
    DocumentSnapshot dc = await path().get();
    bool result = dc.data[TextConfig.messageId].contains(messageId);
    return result;
  }
}