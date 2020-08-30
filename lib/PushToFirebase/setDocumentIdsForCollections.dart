import 'package:cloud_firestore/cloud_firestore.dart';

class SetDocumentIdsForCollections{
  setForBazaarRatingNumbers(String userNumber, String category) async{
    await Firestore.instance.collection("bazaarRatingNumbers").document(userNumber).setData({}, merge: true);
    await Firestore.instance.collection("bazaarRatingNumbers").document(userNumber).collection(category).document("ratings").setData({}, merge: true);
  }

  setForBazaarReviews(String userNumber) async{
    await Firestore.instance.collection("bazaarReviews").document(userNumber).setData({}, merge: true);
  }
}