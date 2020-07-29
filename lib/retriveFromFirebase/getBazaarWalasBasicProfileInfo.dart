import 'package:cloud_firestore/cloud_firestore.dart';

class GetBazaarWalasBasicProfileInfo{
  String userNumber;
  String image;

  GetBazaarWalasBasicProfileInfo({this.userNumber,});

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

  getPicture() async{
    DocumentSnapshot dc = await Firestore.instance.collection("bazaarWalasBasicProfile")
        .document(userNumber).get();

    return dc[image];
  }

  getPictureList() async{
    DocumentSnapshot dc = await Firestore.instance.collection("bazaarWalasBasicProfile")
        .document(userNumber).get();

    Map<String, String> map = new Map();
    map["thumbnailPicture"] = dc["thumbnailPicture"];
    map["otherPictureOne"] = dc["otherPictureOne"];
    map["otherPictureTwo"] = dc["otherPictureTwo"];

    return map;
  }
}