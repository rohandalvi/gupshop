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

  getIsBazaarwala() async{
    DocumentSnapshot dc = await main();
    /// if the user has not registered as a bazaarwala before at all then,
    /// there would be no .collection(categoryData) and hence dc would be null
    if(dc.data == null) return false;

    if(dc.data.isEmpty) return false;
    return true;
  }

  getName() async{
    DocumentSnapshot nameFuture = await main();
    return nameFuture.data["bazaarWalaName"];
  }

  getThumbnailPicture(){

  }

  getNameAndThumbnailPicture() async{
    DocumentSnapshot dc = await main();
    Map<String, String> map = new Map();

    map["name"] = dc.data["bazaarWalaName"];
    map["thumbnailPicture"] = dc.data["thumbnailPicture"];
    return map;
  }

  getPicture() async{
    DocumentSnapshot dc = await main();

    return dc.data[image];
  }

  getPictureListAndVideo() async{
    DocumentSnapshot dc = await main();
    Map<String, String> map = new Map();
    map["thumbnailPicture"] = dc.data["thumbnailPicture"];
    map["otherPictureOne"] = dc.data["otherPictureOne"];
    map["otherPictureTwo"] = dc.data["otherPictureTwo"];
    map["videoURL"] = dc.data["videoURL"];

    return map;
  }

  Future<bool> isHomeService() async{
    DocumentSnapshot dc = await main();
    bool result =  dc.data["homeService"];
    return result;
  }

  getNameThumbnailPictureHomeService() async{
    DocumentSnapshot dc = await main();
    Map<String, dynamic> map = new Map();

    map["name"] = dc.data["bazaarWalaName"];

    map["thumbnailPicture"] = dc.data["thumbnailPicture"];

    if(dc.data["homeService"] == true || dc.data["homeService"] == false){
      map["homeService"] =  dc.data["homeService"];
    }else{
      map["homeService"] = null;
    }


    return map;
  }

  getVideoAndLocation() async{
    DocumentSnapshot dc = await main();
    Map map = new Map();
    if(dc.data != null){
      map["latitude"] = dc.data["latitude"];
      map["longitude"] = dc.data["longitude"];
      map["videoURL"] = dc.data["videoURL"];
      return map;
    }return null;
  }
}