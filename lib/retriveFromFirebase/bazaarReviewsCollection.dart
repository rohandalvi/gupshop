import 'package:cloud_firestore/cloud_firestore.dart';

class BazaarReviewsCollection{
  String productWalaNumber;
  String categoryData;
  String subCategoryData;

  BazaarReviewsCollection({this.productWalaNumber, this.categoryData,this.subCategoryData});
  

  getStream() {
    return Firestore.instance.collection("bazaarReviews").document(productWalaNumber)
        .collection(categoryData).document(subCategoryData).snapshots();
  }
  
  getOrderedStream(){
    return Firestore.instance.collection("bazaarReviews").document(productWalaNumber)
        .collection(categoryData).document(subCategoryData).collection("reviews")
        .orderBy("timestamp", descending: true).snapshots();
  }
  
}