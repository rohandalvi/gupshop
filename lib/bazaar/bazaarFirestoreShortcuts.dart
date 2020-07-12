import 'package:cloud_firestore/cloud_firestore.dart';

class BazaarFirestoreShortcuts{

  addReviewToBazaarReviewsCollection(String productWalaNumber, String category, var data) async{
    await Firestore.instance.collection("bazaarReviews").document(productWalaNumber).collection(category).document().setData(data);
  }

  updateRatingsInBazaarRatingNumbers(String productWalaNumber, String category, int likes, int dislikes){
    print("likes in updateRatings : $likes");
    print("category in updateRatings : $category");
    Firestore.instance.collection("bazaarRatingNumbers").document(productWalaNumber).collection(category).document("ratings").setData({"likes": likes, "dislikes":dislikes});
  }
}