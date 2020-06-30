import 'package:cloud_firestore/cloud_firestore.dart';

class GetConversationDetails{

  conversationWith(String friendCollectionNumber, String number, ) async{
    DocumentSnapshot documentSnapshot = await Firestore.instance.collection("friends_$friendCollectionNumber").document(number).get();
    if(documentSnapshot.data == null) return null;
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
}