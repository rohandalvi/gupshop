import 'package:cloud_firestore/cloud_firestore.dart';

class PushToBazaarReviewsCollection{

  addReview(String productWalaNumber, String category, var data) async{
    await Firestore.instance.collection("bazaarReviews").document(productWalaNumber).collection(category).document().setData(data);
  }
}