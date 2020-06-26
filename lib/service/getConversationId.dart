import 'package:cloud_firestore/cloud_firestore.dart';

class GetConversationId{

  createNewConversationId(String myPhoneNumber, List<dynamic> contactPhoneNumber, String groupName) async{///1
    DocumentReference dc;

    /// making a temp list, becuase any change in contactPhoneNumber list would make a change in individualchat too
    List<dynamic> temp = new List();
    temp.addAll(contactPhoneNumber);
    temp.add(myPhoneNumber);
    if(groupName ==  null){  /// individual chat
     // dc = await Firestore.instance.collection("conversationMetadata").add({ 'myNumber': myPhoneNumber, 'listOfOtherNumbers':contactPhoneNumber});///2
      dc = await Firestore.instance.collection("conversationMetadata").add({'members':temp});///2
    }
//    else dc = await Firestore.instance.collection("conversationMetadata").add({ 'myNumber': myPhoneNumber, 'listOfOtherNumbers':contactPhoneNumber, 'groupName' : groupName});///2
    else dc = await Firestore.instance.collection("conversationMetadata").add({ 'members': temp, 'groupName' : groupName, 'admin' : myPhoneNumber});///2
    String id = dc.documentID;
    print("id in createNewConversationId: $id");
    return id;
  }



}

/// push conversationId to:
/// conversations_number