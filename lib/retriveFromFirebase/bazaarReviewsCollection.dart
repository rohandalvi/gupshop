import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarReviewsCollection.dart';
import 'package:gupshop/responsive/textConfig.dart';

class BazaarReviewsCollection{
  String productWalaNumber;
  String categoryData;
  String subCategoryData;

  BazaarReviewsCollection({this.productWalaNumber, this.categoryData,this.subCategoryData});


  DocumentReference path(){
    return PushToBazaarReviewsCollection().path(productWalaNumber);
  }

  getStream() {
    return path()
        .collection(categoryData).document(subCategoryData).snapshots();
  }
  
  getOrderedStream(){
    return path().collection(categoryData).document(subCategoryData)
        .collection(TextConfig.reviewsCollectionName)
        .orderBy(TextConfig.timeStampReviews, descending: true).snapshots();
  }
  
}