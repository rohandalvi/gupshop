import 'package:cloud_firestore/cloud_firestore.dart';

class PushToBazaarRatingNumber{
  String userNumber;
  String category;
  String subCategory;

  PushToBazaarRatingNumber({this.userNumber, this.category, this.subCategory });

  push(){
    Firestore.instance.collection("bazaarRatingNumbers").document(userNumber).
    collection(category).document(subCategory).setData({'dislikes' : 0, 'likes' : 0});
  }

}