import 'package:cloud_firestore/cloud_firestore.dart';

class RetriveLikesAndDislikesFromBazaarRatingNumbers{
  numberOfLikes(String productWalaNumber, String categoryData, String subCategoryData) async{
    print("categoryData in numberOfLikes : $categoryData");
    print("subCategoryData in numberOfLikes : $subCategoryData");
    DocumentSnapshot dc = await Firestore.instance.collection("bazaarRatingNumbers")
        .document(productWalaNumber).collection(categoryData).document(subCategoryData).get();
    print("dc.data likes in numberOfLikes : ${dc.data["likes"]}");
    return dc.data["likes"];
  }

  numberOfDislikes(String productWalaNumber, String category, String subCategory) async{
    DocumentSnapshot dc =  await Firestore.instance.collection("bazaarRatingNumbers")
        .document(productWalaNumber).collection(category).document(subCategory).get();
    return dc.data["dislikes"];
  }

  numberOfLikesAndDislikes(String productWalaNumber, String category, String subCategory) async{
    print("subCategory in numberOfLikesAndDislikes : $subCategory");
    print("category in numberOfLikesAndDislikes : $category");
    DocumentSnapshot dc = await Firestore.instance.collection("bazaarRatingNumbers")
        .document(productWalaNumber).collection(category).document(subCategory).get();

    Map<String, int> map = new Map();
    map['likes']= dc.data["likes"];
    map['dislikes'] = dc.data["dislikes"];
    print("map in numberOfLikesAndDislikes : $map");

    return map;
  }
}