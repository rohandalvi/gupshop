import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/PushToFirebase/pushToMessageReadUnreadCollection.dart';
import 'package:gupshop/responsive/textConfig.dart';

class UpdateMessageReadUnreadCollection{
  String userNumber;
  String messageId;

  UpdateMessageReadUnreadCollection({this.userNumber, this.messageId});

  DocumentReference path(){
    return PushToMessageReadUnreadCollection().path(userNumber);
  }

  update(){
    List<String> messageIdList = new List();
    messageIdList.add(messageId);
    path().updateData({
      TextConfig.messageId: FieldValue.arrayUnion(messageIdList)
    });
  }

}