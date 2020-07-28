import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateBazaarRatingNumberCollection{
  String productWalaNumber;
  String category;
  int likes;
  int dislikes;

  UpdateBazaarRatingNumberCollection({this.likes, this.dislikes, this.category, this.productWalaNumber});


  updateRatings(){
    print("likes in updateRatings : $likes");
    print("category in updateRatings : $category");
    Firestore.instance.collection("bazaarRatingNumbers").document(productWalaNumber).collection(category).document("ratings").setData({"likes": likes, "dislikes":dislikes});
  }
}