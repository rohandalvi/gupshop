import 'package:cloud_firestore/cloud_firestore.dart';

class RetriveLikesAndDislikesFromBazaarRatingNumbers{
  numberOfLikes(String productWalaNumber, String category, String subCategory) async{
    DocumentSnapshot dc = await Firestore.instance.collection("bazaarRatingNumbers")
        .document(productWalaNumber).collection(category).document(subCategory).get();
    return dc.data["likes"];
  }

  numberOfDislikes(String productWalaNumber, String category, String subCategory) async{
    DocumentSnapshot dc =  await Firestore.instance.collection("bazaarRatingNumbers")
        .document(productWalaNumber).collection(category).document(subCategory).get();
    return dc.data["dislikes"];
  }

  numberOfLikesAndDislikes(String productWalaNumber, String category, String subCategory) async{
    print("subCategory in numberOfLikesAndDislikes : $subCategory");
    DocumentSnapshot dc = await Firestore.instance.collection("bazaarRatingNumbers")
        .document(productWalaNumber).collection(category).document(subCategory).get();

    Map<String, int> map = new Map();
    map['likes']= dc.data["likes"];
    map['dislikes'] = dc.data["dislikes"];

    return map;
  }
}