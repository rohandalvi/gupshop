import 'package:cloud_firestore/cloud_firestore.dart';

class PushToBazaarWalasLocation{
  double latitude;
  double longitude;
  String category;
  String subCategory;
  String userNumber;
  var position;

  PushToBazaarWalasLocation({this.subCategory, this.category, this.userNumber,
    this.longitude, this.latitude, this.position,});


  push(){//used in createBazaarwala profile page

    Firestore.instance.collection("bazaarWalasLocation").document(category).setData({}, merge: true);///creating document to avoid error document(italic) creation
    Firestore.instance.collection("bazaarWalasLocation").document(category).collection(subCategory).document(userNumber).setData(position);
  }

  setBlankLocation(){
    Firestore.instance.collection("bazaarWalasLocation").document(category)
        .collection(subCategory).document(userNumber).setData({}, merge: true);
  }

}