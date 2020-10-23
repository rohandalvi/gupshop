import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

class ConversationMetaData{
  String conversationId;
  String myNumber;

  ConversationMetaData({this.myNumber, this.conversationId});


  DocumentReference path(){
    DocumentReference dc = CollectionPaths.conversationMetadataCollectionPath.document(conversationId);
    print("dc in path : ${dc}");
    return dc;
  }

  Future<Map<String, dynamic>> get(String myNumber) async {
    DocumentSnapshot temp = await path().get();
    print("temp : ${temp.data}");
    return temp.data;
  }

  Future<String> getAdminNumber() async{
    DocumentSnapshot temp = await path().get();

    String adminNumber = temp.data[TextConfig.conversationMetadataAdmin];
    return adminNumber;
  }

  Future<List<dynamic>> listOfNumbersOfConversationExceptMe() async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    DocumentSnapshot temp = await path().get();

    List<dynamic> listOfMembersInConversation = temp.data[TextConfig.conversationMetadataMembers];
    listOfMembersInConversation.remove(userNumber);
    return listOfMembersInConversation;
  }

  Future<String> getGroupName() async{
    DocumentSnapshot temp = await path().get();

    String groupName = temp.data[TextConfig.conversationMetadataGroupName];
    print("groupName : $groupName");
    return groupName;
  }
}