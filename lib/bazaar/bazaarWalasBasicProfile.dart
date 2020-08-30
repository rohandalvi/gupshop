import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class BazaarWalasBasicProfile{
  String userPhoneNo;
  String userName;

  BazaarWalasBasicProfile({@required this.userPhoneNo, @required this.userName});

  pushToFirebase(String videoURL, double latitude, double longitude, double radius) async{
    await Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo).setData({}, merge: true);
    /// add videoURL
    /// home location
    /// categories
    await Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo).setData({'bazaarWalaName': userName,'videoURL': videoURL, 'latitude': latitude, 'longitude': longitude, 'radius' : radius}, merge: true);
  }

}