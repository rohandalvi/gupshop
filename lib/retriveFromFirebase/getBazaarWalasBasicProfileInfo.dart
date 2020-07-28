import 'package:cloud_firestore/cloud_firestore.dart';

class GetBazaarWalasBasicProfileInfo{
  String userNumber;

  GetBazaarWalasBasicProfileInfo({this.userNumber});

  getName() async{
    DocumentSnapshot nameFuture = await Firestore.instance.collection("bazaarWalasBasicProfile")
        .document(userNumber).get();

    return nameFuture["bazaarWalaName"];
  }

  getThumbnailPicture(){

  }

  getNameAndThumbnailPicture() async{
    print("userNumber in getNameAndThumbnailPicture : $userNumber");
    DocumentSnapshot dc = await Firestore.instance.collection("bazaarWalasBasicProfile")
        .document(userNumber).get();

    Map<String, String> map = new Map();

    map["name"] = dc["bazaarWalaName"];
    map["thumbnailPicture"] = dc["thumbnailPicture"];
    return map;
  }
}