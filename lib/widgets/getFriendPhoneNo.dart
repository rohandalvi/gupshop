import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/service/displayAvatarFromFirebase.dart';

class GetFriendPhoneNo extends StatelessWidget {
  final String conversationId;
  final String myNumber;
  GetFriendPhoneNo({this.conversationId, this.myNumber});

  @override
  Widget build(BuildContext context) {
    String friendNumber;
    return FutureBuilder(
      future: getFriendPhoneNo(conversationId, myNumber),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //print("Dat $snapshot");
        print("conversationId in getFriendPhoneNoFB : $conversationId");
        if (snapshot.connectionState == ConnectionState.done) {
          friendNumber = snapshot.data;
          //return DisplayAvatarFromFirebase().getProfilePicture(friendNumber, 35);
          return DisplayAvatarFromFirebase()
              .displayAvatarFromFirebase(friendNumber, 30, 27,
              false); //ToDo- check is false is right here
        }
        return CircularProgressIndicator();
      },
    );
  }

  getFriendPhoneNo(String conversationId, String myNumber) async {
    //print("mynumber in getfriend2 : $myNumber");
    DocumentSnapshot temp = await Firestore.instance.collection(
        "conversationMetadata").document(conversationId).get();
    var friendNo = await extractFriendNo(temp, myNumber);
    return friendNo;
  }

  extractFriendNo(DocumentSnapshot temp, String myNumber) async {
    //print("mynumber in extractfriendNo : $myNumber");
    for (int i = 0; i < 2; i++) {
      if (temp.data["members"][i] != myNumber) {
        return temp.data["members"][i];
      }
    }
    return myNumber;
  }
}
