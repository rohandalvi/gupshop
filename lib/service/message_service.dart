import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService{

  static final String MESSAGE_COLLECTION = "Messages";
  List<Future<DocumentSnapshot>> getMessages(var messageIds) {
    List<Future> promises = getMessagePromises(messageIds);
    return promises;

  }
  List<Future<DocumentSnapshot>> getMessagePromises(var messageIds) {

    List<Future> result =  [];

    for(String messageId in messageIds) {
      CollectionReference collectionReference = Firestore.instance.collection(MESSAGE_COLLECTION);
      collectionReference.orderBy("timestamp",descending: true);
      result.add(collectionReference.document(messageId).get());

    }
    return result;
  }


}