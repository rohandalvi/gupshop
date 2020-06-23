import 'package:cloud_firestore/cloud_firestore.dart';

class CheckIfGroup{

  ifThisIsAGroup(String conversationId) async{
    DocumentSnapshot dc= await Firestore.instance.collection("conversationMetadata").document(conversationId).get();
    print("dc in CheckIfGroup: ${dc.data}");
    return dc.data.containsKey("groupName");
  }
}