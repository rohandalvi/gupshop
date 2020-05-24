import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class RecentChats{
  Map message;
  String userNumber;
  String convId;
  //String friendName;
  //String friendNumber;
  String userName;
  RecentChats({@required this.message, this.userNumber, this.convId, this.userName});


  getAllNumbersOfAConversation() async{
    //get a list of all numbers involved in that conversation
    DocumentSnapshot documentSnapshot = await Firestore.instance.collection("conversationMetadata").document(convId).get();
    List list = documentSnapshot.data["members"];

    /*
    push the recentChat to all the people involved in the conversation
    Usually, its 2 people except groupchat
     */
    for(int i=0; i<list.length; i++){
      print("number: ${list[i]}");
      print("userNumber: $userNumber");
      if(list[i]!=userNumber){//if the user is not chatting with himself then push the friendName as after finding it from conversationMetada from conversationWith()
        String friendName = await conversationWith(list[i], userNumber);//purva dalvi
        print("friendName: $friendName");
        pushRecentChatsToAllNumbersInvolvedInFirebase(userNumber,friendName);//recent chats=> 585 => purva dalvi

        //set our name as friendName in the other user's recent chat
        String otherFriendName = await conversationWith(userNumber, list[i]);
        print("otherfriendName: $otherFriendName");
        pushRecentChatsToAllNumbersInvolvedInFirebase(list[i], otherFriendName);
      }//else pass the user's name as the friendName

    }
  }

  //check with whom the conversation is with
  conversationWith(String number, String friendCollectionNumber) async{
    DocumentSnapshot documentSnapshot = await Firestore.instance.collection("friends_$friendCollectionNumber").document(number).get();
    return documentSnapshot.data["name"];
  }

  pushRecentChatsToAllNumbersInvolvedInFirebase(String number,String friendName) async{
    Firestore.instance.collection("recentChats").document(number).collection("conversations").document(convId).setData({"message": message, "name": friendName});
  }


}
