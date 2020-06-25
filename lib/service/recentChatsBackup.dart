import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class RecentChats{
  Map message;
  String userNumber;
  String convId;
  String userName;
  List<dynamic> listOfOtherNumbers;
  bool groupExists;
  RecentChats({@required this.message, this.userNumber, this.convId, this.userName, @required this.listOfOtherNumbers, @required this.groupExists});


  getAllNumbersOfAConversation() async{
    //get a 'list' of all numbers involved in that conversation
    DocumentSnapshot documentSnapshot = await Firestore.instance.collection("conversationMetadata").document(convId).get();
//    List listOfOtherNumbers = documentSnapshot.data["listOfOtherNumbers"];
//    String myNumber = documentSnapshot.data["myNumber"];
    String groupName = documentSnapshot.data["groupName"];
    String myName;
    String friendName;

    /*
    We are getting a list of all the people involved in the conversation in list
    Now this message has to be passed to all those numbers as their recent message in their recentChats collection.
    Now this recentChats collection needs 'name'. This name means the person with whom the conversation is with, meaning
    the friend name.
    To find this friend name , we have to go through friend_number collection of each phone number involved. We do this
    using conversationWith() method.
    Then we push the message to each number's recentChat collection using that friendName.
     */

    for(int i=0; i<listOfOtherNumbers.length; i++){
      print("number: ${listOfOtherNumbers[i]}");
      ///for a group, the userNumber should be conversationId
      if(groupExists != null){
        myName = await conversationWith(listOfOtherNumbers[i], convId, );
      }
      else myName = await conversationWith(listOfOtherNumbers[i], userNumber, );
      print("myName: $myName");
      pushRecentChatsToAllNumbersInvolvedInFirebase(listOfOtherNumbers[i], myName);
    }
    /// pushing to my recentConversations
    if(groupExists != null) friendName = groupName;
    else friendName = await conversationWith(userNumber, listOfOtherNumbers[0]);
    pushRecentChatsToAllNumbersInvolvedInFirebase(userNumber, friendName);
  }

  //check with whom the conversation is with
  conversationWith(String friendCollectionNumber, String number, ) async{
    print("my number in friends collection: $number");
    print("friendCollectionNumber: $friendCollectionNumber");
    DocumentSnapshot documentSnapshot = await Firestore.instance.collection("friends_$friendCollectionNumber").document(number).get();
    print("documentSnapshot in conversationWith: ${documentSnapshot.data}");
    return documentSnapshot.data["nameList"][0];
  }

  pushRecentChatsToAllNumbersInvolvedInFirebase(String number,String friendName) async{
    DateTime timeStamp = message["timeStamp"];
    print("number in pushRecentChatsToAllNumbersInvolvedInFirebase: $number");
    print("friendName in pushRecentChatsToAllNumbersInvolvedInFirebase: $friendName");
    Firestore.instance.collection("recentChats").document(number).collection("conversations").document(convId).setData({"message": message, "name": friendName, "timeStamp":timeStamp});
  }


}
