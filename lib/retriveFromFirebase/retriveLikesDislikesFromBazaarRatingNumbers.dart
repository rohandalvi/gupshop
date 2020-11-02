import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarRatingNumbers.dart';
import 'package:gupshop/responsive/textConfig.dart';

class RetriveLikesAndDislikesFromBazaarRatingNumbers{

  DocumentReference path(String productWalaNumber){
    print("productWalaNumber in path : $productWalaNumber");
    DocumentReference dr = PushToBazaarRatingNumber().path(productWalaNumber);
    print("dr in path : $dr");
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
    print("productWalaNumber in numberOfLikesAndDislikes: $productWalaNumber");
    print("category in numberOfLikesAndDislikes: $category");
    print("subCategory in numberOfLikesAndDislikes: $subCategory");
    DocumentSnapshot dc = await path(productWalaNumber).collection(category).document(subCategory).get();
    print("dc.data in numberOfLikesAndDislikes: $dc");

    Map<String, int> map = new Map();
    map[TextConfig.likes]= dc.data[TextConfig.likes];
    map[TextConfig.dislikes] = dc.data[TextConfig.dislikes];

    return map;
  }
}