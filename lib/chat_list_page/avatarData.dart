import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/sizeConfig.dart';
import 'package:gupshop/retriveFromFirebase/profilePictures.dart';

class AvatarData{
  final String myNumber;
//  final String conversationId;
//  bool notAGroupMemberAnymore;
//  bool groupExists;
//  String friendNumber;
//  List<dynamic> friendNumberList;
//  List<dynamic> memberList;
//  double radius;
//  double innerRadius;

  AvatarData({this.myNumber,
//    this.conversationId, this.notAGroupMemberAnymore,
//    this.groupExists, this.friendNumber, this.memberList, this.friendNumberList,
  });
//        radius = SizeConfig.imageSizeMultiplier * 7,
//        innerRadius = SizeConfig.imageSizeMultiplier * 6.25;/// radius= 30,30/4 =7, innerRadius = 27

  StreamSubscription<DocumentSnapshot> subscription;
  String imageURL;

  getStream(){
    subscription = Firestore.instance.collection("profilePictures").document(myNumber).snapshots().listen((snapshot) {
      imageURL = snapshot.data['url'];
      print("imageURL in AvatarData : $imageURL");
      return imageURL;
    });
  }

//  disableActiveSubscription()  async {
//    await subscription.cancel();
//    await streamController.close();
//
//  }


//  getFriendPhoneNo(String conversationId, String myNumber) async {
//    DocumentSnapshot temp = await Firestore.instance.collection(
//        "conversationMetadata").document(conversationId).get();
//    return temp.data;
//  }
}
