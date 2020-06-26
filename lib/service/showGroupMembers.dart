import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// take listOfFriendNumbers from IndividualChat
/// match them with the friends_userNumber collection to get the names
/// show the names whose names match and show numbers whose names dont
///

class ShowGroupMembers{
  String userNumber;
  List<dynamic> listOfFriendNumbers;

  findTheNamesOffriends(){
    List<dynamic> result = new List();

    listOfFriendNumbers.forEach((element) async{
      String isFriend = await checkIfAFriend(userNumber, element);
      if(isFriend != null) result.add(isFriend);
    });

  }

  Future<String> checkIfAFriend(String userName, dynamic element) async{
    QuerySnapshot dc = await Firestore.instance.collection("friends_$userNumber").where(element).getDocuments();
    if(dc.documents == null) return null;
//    return dc.documents["nameList"][0];
  }
}