import 'package:cloud_firestore/cloud_firestore.dart';

class SetDocumentIdsForCollections{
  setForBazaarRatingNumbers(String userNumber) async{
    await Firestore.instance.collection("bazaarRatingNumbers").document(userNumber).setData({'dislikes': 0, 'likes': 0});
  }

  setForBazaarReviews(String userNumber) async{
    await Firestore.instance.collection("bazaarReviews").document(userNumber).setData({});
  }
}