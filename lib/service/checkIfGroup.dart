import 'package:cloud_firestore/cloud_firestore.dart';

class CheckIfGroup{

  ifThisIsAGroup(String conversationId) async{
    DocumentSnapshot dc= await Firestore.instance.collection("conversationMetadata").document(conversationId).get();
    return dc.data.containsKey("groupName");
  }

  getGroupName(String conversationId) async{
    DocumentSnapshot dc= await Firestore.instance.collection("conversationMetadata").document(conversationId).get();
    String groupName = dc.data["groupName"];
    return groupName;
  }

  getAdminNumber(String conversationId) async{
    DocumentSnapshot dc= await Firestore.instance.collection("conversationMetadata").document(conversationId).get();
    String admin = dc.data["admin"];
    return admin;
  }
}