import 'package:cloud_firestore/cloud_firestore.dart';

class CheckIfGroup{

  ifThisIsAGroup(String conversationId) async{
    DocumentSnapshot dc= await Firestore.instance.collection("conversationMetadata").document(conversationId).get();
    print("dc in CheckIfGroup: ${dc.data.containsKey("groupName")}");
    return dc.data.containsKey("groupName");
  }

  getGroupName(String conversationId) async{
    DocumentSnapshot dc= await Firestore.instance.collection("conversationMetadata").document(conversationId).get();
    String groupName = dc.data["groupName"];
    return groupName;
  }
}