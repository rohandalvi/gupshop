import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasBasicProfileCollection.dart';
import 'package:gupshop/location/location_service.dart';
import 'package:gupshop/responsive/textConfig.dart';

class GetBazaarWalasBasicProfileInfo{
  String userNumber;
  String image;
  String categoryData;
  String subCategoryData;

  GetBazaarWalasBasicProfileInfo({this.userNumber,this.subCategoryData, this.categoryData, this.image});

  DocumentReference basicPath(){
    return PushToBazaarWalasBasicProfile().categoryDataPath(userPhoneNo: userNumber,
        categoryData: categoryData,subCategoryData: subCategoryData);
  }

  Future<DocumentSnapshot> path() async{
  return await basicPath().get();
  }

  getIsBazaarwala() async{
    DocumentSnapshot dc = await path();
    /// if the user has not registered as a bazaarwala before at all then,
    /// there would be no .collection(categoryData) and hence dc would be null
    if(dc.data == null) return false;

    if(dc.data.isEmpty) return false;
    return true;
  }

  getName() async{
    DocumentSnapshot nameFuture = await path();
    return nameFuture.data[TextConfig.bazaarWalaName];
  }

  getThumbnailPicture(){

  }

  getNameAndThumbnailPicture() async{
    DocumentSnapshot dc = await path();
    Map<String, String> map = new Map();

    map[TextConfig.namebazaawalasBasicProfile] = dc.data[TextConfig.bazaarWalaName];
    map[TextConfig.thumbnailPicture] = dc.data[TextConfig.thumbnailPicture];
    return map;
  }

  getPicture() async{
    DocumentSnapshot dc = await path();

    return dc.data[image];
  }

  getPictureListAndVideo() async{
    DocumentSnapshot dc = await path();
    Map<String, String> map = new Map();
    map[TextConfig.thumbnailPicture] = dc.data[TextConfig.thumbnailPicture];
    map[TextConfig.otherPictureOne] = dc.data[TextConfig.otherPictureOne];
    map[TextConfig.otherPictureTwo] = dc.data[TextConfig.otherPictureTwo];
    map[TextConfig.videoURL] = dc.data[TextConfig.videoURL];
    return map;
  }

  Future<bool> isHomeService() async{
    DocumentSnapshot dc = await path();
    bool result =  dc.data[TextConfig.homeService];
    return result;
  }

  getNameThumbnailPictureHomeService() async{
    DocumentSnapshot dc = await path();
    Map<String, dynamic> map = new Map();

    map[TextConfig.namebazaawalasBasicProfile] = dc.data[TextConfig.bazaarWalaName];

    print("number : $userNumber");
    print("category : $categoryData");
    print("subCategoryData : $subCategoryData");
    String businessName;
    businessName = dc.data[TextConfig.businessName];
    print("businessName in basic profile : ${dc.data["businessName"]}");
    map[TextConfig.businessName] = businessName;

    print("map after businessName : $map");

    map[TextConfig.thumbnailPicture] = dc.data[TextConfig.thumbnailPicture];
    print("map after thumbnailPicture : $map");

    if(dc.data[TextConfig.homeService] == true || dc.data[TextConfig.homeService] == false){
      map[TextConfig.homeService] =  dc.data[TextConfig.homeService];
      print("map after homeService in if  : $map");
    }else{
      map[TextConfig.homeService] = null;
      print("map after homeService in else : $map");
    }

    print("map in getNameThumbnailPictureHomeService : $map");

    return map;
  }

  getVideoAndLocationRadius() async{
    DocumentSnapshot dc = await path();
    Map map = new Map();
    print("dc.data in getVideoAndLocationRadius : ${dc.data}");
    if(dc.data != null){
      map[TextConfig.latitude] = dc.data[TextConfig.latitude];
      map[TextConfig.longitude] = dc.data[TextConfig.longitude];
      map[TextConfig.videoURL] = dc.data[TextConfig.videoURL];
      map[TextConfig.radius] = dc.data[TextConfig.radius];
      return map;
    }return null;
  }

  getLocationRadiusAddressName() async{
    DocumentSnapshot dc = await path();
    Map map = new Map();
    if(dc.data != null){
      double latitude = dc.data[TextConfig.latitude];
      double longitude = dc.data[TextConfig.longitude];
      String addressName = await LocationService().getAddressFromLatLang(latitude,longitude);

      map[TextConfig.latitude] = latitude;
      map[TextConfig.longitude] = longitude;
      map["addressName"] = addressName;
      map[TextConfig.radius] = dc.data[TextConfig.radius];
      return map;
    }return null;
  }

  Stream getPicturesStream(){
    print("in getPicturesStream");
    return basicPath().snapshots();
  }
}