import 'package:cloud_firestore/cloud_firestore.dart';

class AddToFriendsCollection{
  //addToFriendsCollection(List<dynamic> listOfNumbersInAGroup, String id, String myNumberOrConversationId, List<dynamic> nameList, String groupName){
  addToFriendsCollection(List<dynamic> friendNumberList,String id,String userPhoneNo,  List<dynamic> nameList,  String groupName){
    if(groupName != null){
      List<dynamic> idList = new List();
      idList.add(id);
      Firestore.instance.collection("friends_$userPhoneNo").document(id).setData({'phone': idList, 'nameList' : nameList, 'conversationId': id, 'groupName': groupName},merge: true);
    }
    else {
      String frienN = friendNumberList[0];
      Firestore.instance.collection("friends_$userPhoneNo").document(frienN).setData({'phone': friendNumberList, 'nameList' : nameList, 'conversationId': id},merge: true);
    }

  }

  ///in case of a group, friendNumber would be conversationId
  extractNumbersFromListAndAddToFriendsCollection(List<dynamic> listOfNumbersInAGroup, String id, String myNumberOrConversationId, List<dynamic> nameList, String groupName){
    print("listOfNumbersInAGroup in extract: ${listOfNumbersInAGroup}");
    for(int i=0; i<listOfNumbersInAGroup.length; i++){
      String friendNumber = listOfNumbersInAGroup[i];
      List<String> list = new List();
      list.add(myNumberOrConversationId);
      addToFriendsCollection( list, id,friendNumber, nameList, groupName);
    }
  }
}