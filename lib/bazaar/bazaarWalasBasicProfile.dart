import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class BazaarWalasBasicProfile{
  String userPhoneNo;
  String userName;

  BazaarWalasBasicProfile({@required this.userPhoneNo, @required this.userName});

  pushToFirebase(String videoURL, var homeLocation, List<String> categories, String categoryName) async{
    await Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo).setData({}, merge: true);
    /// add videoURL
    /// home location
    /// categories
    await Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo).collection(userName).add({'videoURL': videoURL, 'homeLocation': homeLocation, 'categories':categories});
  }
}