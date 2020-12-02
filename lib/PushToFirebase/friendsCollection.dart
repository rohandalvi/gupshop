import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';


class FriendsCollection{
  String userPhoneNo;

  FriendsCollection({this.userPhoneNo});

  CollectionReference path(){
    CollectionReference dc =  CollectionPaths.getFriendsCollectionPath(userPhoneNo: userPhoneNo);
    return dc;
  }


  setMeAsFriend(List<String> phoneNumberList, List<String> nameList,){
    DocumentReference dc = path().document(userPhoneNo);
    return dc.setData({TextConfig.phone: phoneNumberList, TextConfig.nameList : nameList, TextConfig.groupName : null, TextConfig.isMe: true}, merge: true);
  }

  addFriend({@required List<String> listOfNumbers,@required List<String> userNames,@required String friendNumber}){
    DocumentReference dc = path().document(friendNumber);
    return dc.setData({
      TextConfig.phone: listOfNumbers,
      TextConfig.nameList: userNames,
      TextConfig.groupName: null,
      TextConfig.isMe: null
    }, merge: true);
  }
}