import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/service/displayAvatarFromFirebase.dart';
import 'package:gupshop/service/findFriendNumber.dart';

class AvatarData extends StatelessWidget {
  final String myNumber;
  final String conversationId;
  bool notAGroupMemberAnymore;
  bool groupExists;
  String friendNumber;
  List<dynamic> friendNumberList;
  List<dynamic> memberList;

  AvatarData({this.myNumber, this.conversationId, this.notAGroupMemberAnymore,
    this.groupExists, this.friendNumber, this.memberList, this.friendNumberList,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getFriendPhoneNo(conversationId, myNumber),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          memberList = snapshot.data["members"];

          /// if a member is removed from the group, then he should not be seeing the conversations
          /// once he enters the individual chat page
          if(memberList.contains(myNumber) == false) notAGroupMemberAnymore = true;

          if(snapshot.data["groupName"]  == null){
            groupExists = false;
            /// 1. extract memberList from conversationMetadata for navigating to individualChat
            memberList = snapshot.data["members"];
            /// 2. extract friendNumber for DisplayAvatarFromFirebase
            friendNumber = FindFriendNumber().friendNumber(memberList, myNumber);
            /// 3. create friendNumberList to send to individualChat
            friendNumberList = FindFriendNumber().createListOfFriends(memberList, myNumber);
          } else{
            groupExists = true;
            /// for groups, conversationId is used as documentId for
            /// getting profilePicture
            /// profile_pictures -> conversationId -> url
            friendNumberList = FindFriendNumber().createListOfFriends(memberList, myNumber);
            friendNumber = conversationId;
          }
          return DisplayAvatarFromFirebase()
              .displayAvatarFromFirebase(friendNumber, 30, 27,
              false);
        }
        return CircularProgressIndicator();
      },
    );
  }

  getFriendPhoneNo(String conversationId, String myNumber) async {
    DocumentSnapshot temp = await Firestore.instance.collection(
        "conversationMetadata").document(conversationId).get();
    return temp.data;
  }
}
