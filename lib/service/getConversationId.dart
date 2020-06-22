import 'package:cloud_firestore/cloud_firestore.dart';

class GetConversationId{

  createNewConversationId(String myPhoneNumber, String contactPhoneNumber) async{
    DocumentReference dc = await Firestore.instance.collection("conversationMetadata").add({ 'members': [myPhoneNumber, contactPhoneNumber]});
    String id = dc.documentID;
    print("id in createNewConversationId: $id");
    return id;
  }



}

/// push conversationId to:
/// conversations_number