import 'package:cloud_firestore/cloud_firestore.dart';

class GetConversationDetails{

  conversationWith(String friendCollectionNumber, String number, ) async{
    print("friendCollectionNumber: $friendCollectionNumber");
    DocumentSnapshot documentSnapshot = await Firestore.instance.collection("friends_$friendCollectionNumber").document(number).get();
    if(documentSnapshot.data == null) return null;
    print("documentSnapshot.data[nameList][0] : ${documentSnapshot.data["nameList"][0]}");
    return documentSnapshot.data["nameList"][0];
  }

  Future<String> getUserNameFromUsersCollection(String number) async{
    DocumentSnapshot dc = await Firestore.instance.collection("users").document(number).get();
    String name = dc.data["name"];
    return name;
  }

  getMemberList(String conversationId) async{
    DocumentSnapshot dc = await Firestore.instance.collection("conversationMetadata").document(conversationId).get();
    List<dynamic> list = dc.data["members"];
    print("list: $list");
    return list;
  }

  knowWhoIsAdmin(String conversationId) async{
    DocumentSnapshot adminNumberFuture = await Firestore.instance.collection("conversationMetadata").document(conversationId).get();
    return adminNumberFuture.data["admin"];
  }

  getGroupName(String conversationId) async{
    DocumentSnapshot groupNameFuture = await Firestore.instance.collection("conversationMetadata").document(conversationId).get();
    return groupNameFuture.data["groupName"];
  }
}