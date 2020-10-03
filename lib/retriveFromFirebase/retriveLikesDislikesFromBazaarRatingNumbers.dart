import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarRatingNumbers.dart';
import 'package:gupshop/responsive/textConfig.dart';

class RetriveLikesAndDislikesFromBazaarRatingNumbers{

  path(String productWalaNumber) async{
    return PushToBazaarRatingNumber().path(productWalaNumber);
  }

  numberOfLikes(String productWalaNumber, String categoryData, String subCategoryData) async{
    DocumentSnapshot dc = await path(productWalaNumber).collection(categoryData).document(subCategoryData).get();
    return dc.data[TextConfig.likesBazaarRatingNumbers];
  }

  numberOfDislikes(String productWalaNumber, String category, String subCategory) async{
    DocumentSnapshot dc =  await path(productWalaNumber).collection(category).document(subCategory).get();
    return dc.data[TextConfig.dislikesBazaarRatingNumbers];
  }

  numberOfLikesAndDislikes(String productWalaNumber, String category, String subCategory) async{
    DocumentSnapshot dc = await path(productWalaNumber).collection(category).document(subCategory).get();

    Map<String, int> map = new Map();
    map[TextConfig.likesBazaarRatingNumbers]= dc.data[TextConfig.likesBazaarRatingNumbers];
    map[TextConfig.dislikesBazaarRatingNumbers] = dc.data[TextConfig.dislikesBazaarRatingNumbers];

    return map;
  }
}