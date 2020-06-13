import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class RecentChats{
  Map message;
  String userNumber;
  String convId;
  String userName;
  RecentChats({@required this.message, this.userNumber, this.convId, this.userName});


  getAllNumbersOfAConversation() async{
    //get a 'list' of all numbers involved in that conversation
    DocumentSnapshot documentSnapshot = await Firestore.instance.collection("conversationMetadata").document(convId).get();
    List list = documentSnapshot.data["members"];

    /*
    We are getting a list of all the people involved in the conversation in list
    Now this message has to be passed to all those numbers as their recent message in their recentChats collection.
    Now this recentChats collection needs 'name'. This name means the person with whom the conversation is with, meaning
    the friend name.
    To find this friend name , we have to go through friend_number collection of each phone number involved. We do this
    using conversationWith() method.
    Then we push the message to each number's recentChat collection using that friendName.
     */
    for(int i=0; i<list.length; i++){
      print("number: ${list[i]}");
      print("userNumber: $userNumber");
      if(list[i]!=userNumber){//if the user is not chatting with himself then push the friendName as after finding it from conversationMetada from conversationWith()
        String friendName = await conversationWith(list[i], userNumber);//purva dalvi
        print("friendName: $friendName");
        pushRecentChatsToAllNumbersInvolvedInFirebase(userNumber,friendName);//recent chats=> 585 => purva dalvi

        //set our name as friendName in the other user's recent chat
        ///right now messages are not getting updated in otherNumber because no other
        ///friends collection except +19194134191 @ToDo
        String otherFriendName = await conversationWith(userNumber, list[i]);
        print("otherfriendName: $otherFriendName");
        pushRecentChatsToAllNumbersInvolvedInFirebase(list[i], otherFriendName);
      }//else do nothing

    }
  }

  //check with whom the conversation is with
  conversationWith(String number, String friendCollectionNumber) async{
    print("friendCollectionNumber: $friendCollectionNumber");
    DocumentSnapshot documentSnapshot = await Firestore.instance.collection("friends_$friendCollectionNumber").document(number).get();
    print("documentSnapshot in conversationWith: $documentSnapshot");
    return documentSnapshot.data["nameList"][0];
  }

  pushRecentChatsToAllNumbersInvolvedInFirebase(String number,String friendName) async{
    DateTime timeStamp = message["timeStamp"];
    print("timeStamp : $timeStamp");
    Firestore.instance.collection("recentChats").document(number).collection("conversations").document(convId).setData({"message": message, "name": friendName, "timeStamp":timeStamp});
  }


}
