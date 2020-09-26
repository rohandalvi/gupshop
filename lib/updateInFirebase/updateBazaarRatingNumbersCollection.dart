import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarTrace.dart';

class UpdateBazaarRatingNumberCollection{
  String productWalaNumber;
  String categoryData;
  int likes;
  int dislikes;
  String subCategoryData;
  var data;

  UpdateBazaarRatingNumberCollection({this.likes, this.dislikes, this.categoryData,
    this.productWalaNumber, this.subCategoryData, this.data});


  updateRatings(){
    Firestore.instance.collection("bazaarRatingNumbers").document(productWalaNumber).collection(categoryData).document(subCategoryData).setData({"likes": likes, "dislikes":dislikes});


    ///Trace
    if(data["like"] == true){
      BazaarTrace(category: categoryData, subCategory: subCategoryData).positiveRatingAdded(productWalaNumber);
    }
    if(data["dislike"] == true){
      BazaarTrace(category: categoryData, subCategory: subCategoryData).negativeRatingAdded(productWalaNumber);
    }
  }
}