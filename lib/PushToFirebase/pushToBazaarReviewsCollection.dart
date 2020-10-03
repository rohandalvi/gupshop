import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarTrace.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

class PushToBazaarReviewsCollection{
  String productWalaNumber;
  String category;
  var data;
  String subCategory;

  PushToBazaarReviewsCollection({this.productWalaNumber, this.category, this.data, this.subCategory});

  DocumentReference path(String productWalaNumber){
    DocumentReference dc = CollectionPaths.bazaarReviewsCollectionPath.document(productWalaNumber);
    return dc;
  }


  addReview(String productWalaNumber, String category, var data,) async{
    /// .collection("reviews") is needed because we are later using 'orderBy'
    /// on bazaarReviews and 'orderBy' can be used only on a collection
    await path(productWalaNumber).collection(category).document(subCategory)
        .collection(TextConfig.reviewsCollectionName)
        .add(data);



    ///Trace
    BazaarTrace(category: category, subCategory: subCategory).reviewAdded(productWalaNumber);
  }


  setBlankReviews(){
    path(productWalaNumber).setData({}, merge: true);

    path(productWalaNumber).collection(category).document(subCategory)
        .setData({}, merge: true);
  }
}