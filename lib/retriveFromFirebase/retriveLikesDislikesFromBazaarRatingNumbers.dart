import 'package:cloud_firestore/cloud_firestore.dart';

class RetriveLikesAndDislikesFromBazaarRatingNumbers{
  numberOfLikes(String productWalaNumber, String category) async{
    DocumentSnapshot dc = await Firestore.instance.collection("bazaarRatingNumbers").document(productWalaNumber).collection(category).document("ratings").get();
    return dc.data["likes"];
  }

  numberOfDislikes(String productWalaNumber, String category) async{
    DocumentSnapshot dc =  await Firestore.instance.collection("bazaarRatingNumbers").document(productWalaNumber).collection(category).document("ratings").get();
    return dc.data["dislikes"];
  }
}