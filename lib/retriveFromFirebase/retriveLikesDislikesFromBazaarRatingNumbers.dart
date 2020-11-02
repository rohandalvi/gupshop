import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarRatingNumbers.dart';
import 'package:gupshop/responsive/textConfig.dart';

class RetriveLikesAndDislikesFromBazaarRatingNumbers{

  DocumentReference path(String productWalaNumber){
    DocumentReference dr = PushToBazaarRatingNumber().path(productWalaNumber);
    return dr;
  }

  numberOfLikes(String productWalaNumber, String categoryData, String subCategoryData) async{
    DocumentSnapshot dc = await path(productWalaNumber).collection(categoryData).document(subCategoryData).get();
    return dc.data[TextConfig.likes];
  }

  numberOfDislikes(String productWalaNumber, String category, String subCategory) async{
    DocumentSnapshot dc =  await path(productWalaNumber).collection(category).document(subCategory).get();
    return dc.data[TextConfig.dislikes];
  }

  numberOfLikesAndDislikes(String productWalaNumber, String category, String subCategory) async{
    DocumentSnapshot dc = await path(productWalaNumber).collection(category).document(subCategory).get();

    Map<String, int> map = new Map();
    map[TextConfig.likes]= dc.data[TextConfig.likes];
    map[TextConfig.dislikes] = dc.data[TextConfig.dislikes];

    return map;
  }
}