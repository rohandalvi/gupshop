import 'package:cloud_firestore/cloud_firestore.dart';

class BazaarRatingNumbers{
  String userNumber;
  String categoryName;
  String subCategory;

  BazaarRatingNumbers({this.userNumber, this.categoryName, this.subCategory});

  getRatingSnapshot(){
    return Firestore.instance.collection("bazaarRatingNumbers").document(userNumber).collection(categoryName)
        .document(subCategory).snapshots();
  }

}