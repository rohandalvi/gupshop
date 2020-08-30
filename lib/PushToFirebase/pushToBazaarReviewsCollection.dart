import 'package:cloud_firestore/cloud_firestore.dart';

class PushToBazaarReviewsCollection{
  String productWalaNumber;
  String category;
  var data;
  String subCategory;

  PushToBazaarReviewsCollection({this.productWalaNumber, this.category, this.data, this.subCategory});

//  addReview(String productWalaNumber, String category, var data,) async{
//    await Firestore.instance.collection("bazaarReviews").document(productWalaNumber)
//        .collection(category).document().setData(data);
//  }

  addReview(String productWalaNumber, String category, var data,) async{
    await Firestore.instance.collection("bazaarReviews").document(productWalaNumber)
        .collection(category).document(subCategory).collection("reviews")
        .add(data);
  }

  setBlankReviews(){
    Firestore.instance.collection("bazaarReviews").document(productWalaNumber).setData({}, merge: true);

    Firestore.instance.collection("bazaarReviews").document(productWalaNumber)
        .collection(category).document(subCategory).setData({}, merge: true);
  }
}