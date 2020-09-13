import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateBazaarRatingNumberCollection{
  String productWalaNumber;
  String categoryData;
  int likes;
  int dislikes;
  String subCategoryData;

  UpdateBazaarRatingNumberCollection({this.likes, this.dislikes, this.categoryData, this.productWalaNumber, this.subCategoryData});


  updateRatings(){
    print("likes in updateRatings : $likes");
    print("category in updateRatings : $categoryData");
    Firestore.instance.collection("bazaarRatingNumbers").document(productWalaNumber).collection(categoryData).document(subCategoryData).setData({"likes": likes, "dislikes":dislikes});
  }
}