import 'package:cloud_firestore/cloud_firestore.dart';

class GetBazaarWalasBasicProfileInfo{
  String userNumber;
  String image;
  String categoryData;
  String subCategoryData;

  GetBazaarWalasBasicProfileInfo({this.userNumber,this.subCategoryData, this.categoryData, this.image});

  main(){
  return Firestore.instance.collection("bazaarWalasBasicProfile")
      .document(userNumber)
      .collection(categoryData).document(subCategoryData)
      .get();
  }

  getName() async{
    DocumentSnapshot nameFuture = await main();
    return nameFuture["bazaarWalaName"];
  }

  getThumbnailPicture(){

  }

  getNameAndThumbnailPicture() async{
    DocumentSnapshot dc = await main();
    Map<String, String> map = new Map();

    map["name"] = dc["bazaarWalaName"];
    map["thumbnailPicture"] = dc["thumbnailPicture"];
    return map;
  }

  getPicture() async{
    DocumentSnapshot dc = await main();

    return dc[image];
  }

  getPictureListAndVideo() async{
    DocumentSnapshot dc = await main();
    Map<String, String> map = new Map();
    map["thumbnailPicture"] = dc["thumbnailPicture"];
    map["otherPictureOne"] = dc["otherPictureOne"];
    map["otherPictureTwo"] = dc["otherPictureTwo"];
    map["videoURL"] = dc["videoURL"];

    return map;
  }

  Future<bool> isHomeService() async{
    DocumentSnapshot dc = await main();
    bool result =  dc["homeService"];
    return result;
  }

  getNameThumbnailPictureHomeService() async{
    DocumentSnapshot dc = await main();
    Map<String, String> map = new Map();

    map["name"] = dc["bazaarWalaName"];
    map["thumbnailPicture"] = dc["thumbnailPicture"];
    map["homeService"] =  dc["homeService"];
    return map;
  }
}