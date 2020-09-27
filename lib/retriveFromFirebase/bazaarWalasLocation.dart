import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

class BazaarWalasLocation{

  getListOfBazaarWalasGivenAHashList({List<String> userGeoHashList, String category, String subCategory}) async{
    QuerySnapshot futureBazaarWalaUpperGeoHashList= await CollectionPaths.bazaarWalasLocationCollectionPath
        .document(category).collection(subCategory)
        .where(TextConfig.bazaarWalasLocationCollectionGeoHashList, arrayContainsAny: userGeoHashList).getDocuments();

    return futureBazaarWalaUpperGeoHashList.documents;
  }
}