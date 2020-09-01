import 'package:cloud_firestore/cloud_firestore.dart';

class GetBazaarWalasBasicProfileInfo{
  String userNumber;
  String image;
  String categoryData;
  String subCategoryData;

  GetBazaarWalasBasicProfileInfo({this.userNumber,this.subCategoryData, this.categoryData, this.image});

  getName() async{
    DocumentSnapshot nameFuture = await Firestore.instance.collection("bazaarWalasBasicProfile")
        .document(userNumber)
        .collection(categoryData).document(subCategoryData)
        .get();

    return nameFuture["bazaarWalaName"];
  }

  getThumbnailPicture(){

  }

  getNameAndThumbnailPicture() async{
    print("userNumber in getNameAndThumbnailPicture : $userNumber");
    DocumentSnapshot dc = await Firestore.instance.collection("bazaarWalasBasicProfile")
        .document(userNumber)
        .collection(categoryData).document(subCategoryData)
        .get();

    Map<String, String> map = new Map();

    map["name"] = dc["bazaarWalaName"];
    map["thumbnailPicture"] = dc["thumbnailPicture"];
    return map;
  }

  getPicture() async{
    DocumentSnapshot dc = await Firestore.instance.collection("bazaarWalasBasicProfile")
        .document(userNumber)
        .collection(categoryData).document(subCategoryData)
        .get();

    return dc[image];
  }

  getPictureListAndVideo() async{
    DocumentSnapshot dc = await Firestore.instance.collection("bazaarWalasBasicProfile")
        .document(userNumber).collection(categoryData).document(subCategoryData).get();

    print("dc in getPictureListAndVideo : ${dc.data}");
    Map<String, String> map = new Map();
    map["thumbnailPicture"] = dc["thumbnailPicture"];
    map["otherPictureOne"] = dc["otherPictureOne"];
    map["otherPictureTwo"] = dc["otherPictureTwo"];
    map["videoURL"] = dc["videoURL"];

    return map;
  }
}