import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/location/location_service.dart';


class FilterBazaarWalas extends StatefulWidget{
  @override
  FilterBazaarWalasState createState() => FilterBazaarWalasState();
}

class FilterBazaarWalasState extends State<FilterBazaarWalas> {

  getListOfBazaarWalasInAGivenRadius(String number, String category) async{
    var userGeohash = await getUserGeohash(number);

    var listOfUpperGeohashBazaarWalas = await getListOfUpperGeohashBazaarWalas(userGeohash, category );

    return filterListOfLowerGeohashBazaarWalas(listOfUpperGeohashBazaarWalas, userGeohash);
  }

  getUserGeohash(String number) async{
    DocumentSnapshot userGeohash = await LocationServiceState().getUserLocation(number);
    return userGeohash.data["home"]["geohash"];
  }

  getListOfUpperGeohashBazaarWalas(String userGeohash, String category) async{
    QuerySnapshot futureBazaarWalaUpperGeoHashList= await Firestore.instance.collection("bazaarWalasLocation")
        .document(category).collection(category)
        .where("upperGeoHash", isGreaterThanOrEqualTo: userGeohash).getDocuments();

    return futureBazaarWalaUpperGeoHashList.documents;
  }

  filterListOfLowerGeohashBazaarWalas(List<DocumentSnapshot> list, String userGeohash){
    List<DocumentSnapshot> result = new List();


    for(int i=0; i<list.length; i++){
      String lowerGeoHash=list[i].data["lowerGeoHash"];
      if(userGeohash.compareTo(lowerGeoHash) >= 0)  result.add(list[i]);

    }
    return result;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }
}