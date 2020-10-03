import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

class PushToBazaarRatingNumber{
  String userNumber;
  String category;
  String subCategory;

  PushToBazaarRatingNumber({this.userNumber, this.category, this.subCategory });

  DocumentReference path(String userNumber){
    DocumentReference dc = CollectionPaths.bazaarRatingNumbersCollectionPath.document(userNumber);
    return dc;
  }

  push(){
    path(userNumber).setData({}, merge: true);

    path(userNumber).collection(category).document(subCategory).setData({TextConfig.dislikesBazaarRatingNumbers : 0, TextConfig.likesBazaarRatingNumbers : 0});
  }

}