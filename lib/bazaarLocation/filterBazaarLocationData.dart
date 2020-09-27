import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/retriveFromFirebase/bazaarWalasLocation.dart';

class FilterBazaarLocationData{
  final String subCategory;

  FilterBazaarLocationData({this.subCategory});

  /// geohash change here
//  getListOfBazaarWalasInAGivenRadius(String number, String category, String userGeohash) async{
//    //var userGeohash = await getUserGeohash(number,);
//
//    var listOfUpperGeohashBazaarWalas = await getListOfUpperGeohashBazaarWalas(userGeohash, category );
//
//
//    return filterListOfLowerGeohashBazaarWalas(listOfUpperGeohashBazaarWalas, userGeohash);
//  }

  Future<List<String>> getUserGeohashList(String number,) async{
    DocumentSnapshot userGeohash = await LocationService().getUserLocationDocumentSnapshot(number);
    List<String> result = userGeohash.data[TextConfig.usersLocationCollectionHome][TextConfig.usersLocationCollectionGeoHashList].cast<String>();
    return result;
  }


//  getListOfUpperGeohashBazaarWalas(String userGeohash, String category) async{
//    QuerySnapshot futureBazaarWalaUpperGeoHashList= await Firestore.instance.collection("bazaarWalasLocation")
//        .document(category).collection(subCategory)
//        .where("upperGeoHash", isGreaterThanOrEqualTo: userGeohash).getDocuments();
//
//
//    return futureBazaarWalaUpperGeoHashList.documents;
//  }


//  filterListOfLowerGeohashBazaarWalas(List<DocumentSnapshot> list, String userGeohash){
//    List<DocumentSnapshot> result = new List();
//
//
//    for(int i=0; i<list.length; i++){
//      String lowerGeoHash=list[i].data["lowerGeoHash"];
//      if(userGeohash.compareTo(lowerGeoHash) >= 0)  result.add(list[i]);
//
//    }
//    return result;
//  }


  /// /////////////////////////////////////////////////////////////////////////////////////////

  getListOfBazaarWalasInAGivenRadius(String number, String category, List<String> userGeoHashList) async{
    //var userGeohash = await getUserGeohash(number,);

    var listOfUpperGeohashBazaarWalas = await BazaarWalasLocation()
        .getListOfBazaarWalasGivenAHashList(category: category,subCategory: subCategory,userGeoHashList: userGeoHashList);


    return listOfUpperGeohashBazaarWalas;
  }
}