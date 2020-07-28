import 'package:cloud_firestore/cloud_firestore.dart';

class BazaarRatingNumbers{
  String userNumber;
  String categoryName;

  BazaarRatingNumbers({this.userNumber, this.categoryName});

  getRatingSnapshot(){
    return Firestore.instance.collection("bazaarRatingNumbers").document(userNumber).collection(categoryName).document("ratings").snapshots();
  }

}