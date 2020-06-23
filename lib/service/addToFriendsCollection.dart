import 'package:cloud_firestore/cloud_firestore.dart';

class AddToFriendsCollection{
  addToFriendsCollection(String userPhoneNo, List<dynamic> friendNumberList, List<dynamic> nameList, String id, String groupName){
    if(groupName != null){
      Firestore.instance.collection("friends_$userPhoneNo").document(id).setData({'phone': friendNumberList, 'nameList' : nameList, 'conversationId': id, 'groupName': groupName},merge: true);
    }
    else {
      String frienN = friendNumberList[0];
      Firestore.instance.collection("friends_$userPhoneNo").document(frienN).setData({'phone': friendNumberList, 'nameList' : nameList, 'conversationId': id},merge: true);
    }

  }

  ///in case of a group, friendNumber would be conversationId
  extractNumbersFromListAndAddToFriendsCollection(List<dynamic> listOfNumbersInAGroup, String id, String myNumberOrConversationId, List<dynamic> nameList, String groupName){
    for(int i=0; i<listOfNumbersInAGroup.length; i++){
      String friendNumber = listOfNumbersInAGroup[i];
      List<String> list = new List();
      list.add(myNumberOrConversationId);
      addToFriendsCollection(friendNumber, list, nameList, id, groupName);
    }
  }
}