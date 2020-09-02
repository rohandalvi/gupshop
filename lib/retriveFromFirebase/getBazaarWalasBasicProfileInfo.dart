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
    print("in getNameThumbnailPictureHomeService");
    DocumentSnapshot dc = await main();
    print("dc in getNameThumbnailPictureHomeService : ${dc.data}");
    Map<String, dynamic> map = new Map();

    map["name"] = dc.data["bazaarWalaName"];
    print("map after name : $map");
    map["thumbnailPicture"] = dc.data["thumbnailPicture"];
    print("map after thumbnailPicture : $map");
    print("dc.data[homeService] : ${dc.data["homeService"]}");
    if(dc.data["homeService"] == true || dc.data["homeService"] == false){
      map["homeService"] =  dc.data["homeService"];
      print("map in if : $map");
    }else{
      map["homeService"] = null;
      print("in else");
      print("map in else : $map");
    }

    print("map after homeService : $map");

    print("map in getNameThumbnailPictureHomeService : $map");
    return map;
  }
}