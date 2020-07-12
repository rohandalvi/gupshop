import 'package:cloud_firestore/cloud_firestore.dart';

class LikesAndDislikes{
  numberOfLikes(String productWalaNumber) async{
    DocumentSnapshot dc = await Firestore.instance.collection("bazaarRatingNumbers").document(productWalaNumber).get();
    return dc.data["likes"];
  }

  numberOfDislikes(String productWalaNumber) async{
    DocumentSnapshot dc =  await Firestore.instance.collection("bazaarRatingNumbers").document(productWalaNumber).get();
    return dc.data["dislikes"];
  }
}