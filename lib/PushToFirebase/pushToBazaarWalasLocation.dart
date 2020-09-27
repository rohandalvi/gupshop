import 'package:gupshop/responsive/collectionPaths.dart';

class PushToBazaarWalasLocation{
  double latitude;
  double longitude;
  String category;
  String subCategory;
  String userNumber;
  var position;

  PushToBazaarWalasLocation({this.subCategory, this.category, this.userNumber,
    this.longitude, this.latitude, this.position,});


  push(){//used in createBazaarwala profile page

    CollectionPaths.bazaarWalasLocationCollectionPath.document(category).setData({}, merge: true);///creating document to avoid error document(italic) creation
    CollectionPaths.bazaarWalasLocationCollectionPath.document(category).collection(subCategory).document(userNumber).setData(position);
  }

  setBlankLocation(){
    CollectionPaths.bazaarWalasLocationCollectionPath.document(category).setData({}, merge: true);///creating document to avoid error document(i
    CollectionPaths.bazaarWalasLocationCollectionPath.document(category)
        .collection(subCategory).document(userNumber).setData({}, merge: true);
  }

}