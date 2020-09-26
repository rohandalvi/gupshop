import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarTrace.dart';

class PushToBazaarReviewsCollection{
  String productWalaNumber;
  String category;
  var data;
  String subCategory;

  PushToBazaarReviewsCollection({this.productWalaNumber, this.category, this.data, this.subCategory});

  addReview(String productWalaNumber, String category, var data,) async{
    /// .collection("reviews") is needed because we are later using 'orderBy'
    /// on bazaarReviews and 'orderBy' can be used only on a collection
    await Firestore.instance.collection("bazaarReviews").document(productWalaNumber)
        .collection(category).document(subCategory).collection("reviews")
        .add(data);



    ///Trace
    BazaarTrace(category: category, subCategory: subCategory).reviewAdded(productWalaNumber);
  }


  setBlankReviews(){
    Firestore.instance.collection("bazaarReviews").document(productWalaNumber).setData({}, merge: true);

    Firestore.instance.collection("bazaarReviews").document(productWalaNumber)
        .collection(category).document(subCategory).setData({}, merge: true);
  }
}