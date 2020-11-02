import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/bazaarOnBoarding/bazaarTrace.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/responsive/textConfig.dart';

class PushToBazaarWalasBasicProfile{
  String userPhoneNo;
  String userName;
  String thumbnailPicture;
  String otherPictureOne;
  String otherPictureTwo;

  String videoURL;
  double latitude;
  double longitude;
  List<String> categoryList;
  String categoryData;
  String subCategoryData;
  double radius;
  bool homeService;

  PushToBazaarWalasBasicProfile({@required this.userPhoneNo, this.userName,
    this.thumbnailPicture, this.otherPictureTwo, this.otherPictureOne, this.subCategoryData,
    this.categoryData, this.homeService, this.radius, this.longitude, this.latitude,
    this.categoryList, this.videoURL
  });


  DocumentReference path(String userPhoneNo){
    DocumentReference dc = CollectionPaths.bazaarWalasBasicProfileCollectionPath.document(userPhoneNo);
    return dc;
  }

  DocumentReference categoryDataPath({String userPhoneNo,String categoryData, String subCategoryData }){
    DocumentReference dc =  path(userPhoneNo).collection(categoryData).document(subCategoryData);
    return dc;
  }

  DocumentReference categoryNamePath(String categoryName, String subCategoryName){
    DocumentReference dc =  path(userPhoneNo).collection(categoryName).document(subCategoryName);
    return dc;
  }

  pushToFirebase() async{
    await path(userPhoneNo).setData({}, merge: true);

    await categoryDataPath(userPhoneNo: userPhoneNo,
      subCategoryData: subCategoryData,categoryData: categoryData ).setData({TextConfig.bazaarWalaName: userName,
      TextConfig.videoURL: videoURL,
      TextConfig.latitude: latitude,
      TextConfig.longitude: longitude,TextConfig.radius : radius,}, merge: true);
  }

  pushHomeService() async{
    await categoryDataPath(userPhoneNo: userPhoneNo,
        subCategoryData: subCategoryData,categoryData: categoryData ).setData({TextConfig.homeService : homeService }, merge: true);

    ///Trace
    BazaarTrace(category: categoryData, subCategory: subCategoryData).homeServiceAdded();
  }

  pushAllPictures(String categoryName, String subCategoryName) async{
    await categoryNamePath(categoryName, subCategoryName)
        .setData({TextConfig.thumbnailPicture:thumbnailPicture,
      TextConfig.otherPictureOne:otherPictureOne,
      TextConfig.otherPictureTwo :otherPictureTwo }, merge: true);
  }

  pushThumbnailPicture(String categoryName, String subCategoryName) async{
    await categoryNamePath(categoryName, subCategoryName)
        .setData({TextConfig.thumbnailPicture:thumbnailPicture,}, merge: true);
  }

  pushOtherPictureOne(String categoryName, String subCategoryName) async{
    await categoryNamePath(categoryName, subCategoryName)
        .setData({ TextConfig.otherPictureOne:otherPictureOne}, merge: true);
  }

  pushOtherPictureTwo(String categoryName, String subCategoryName) async{
    await categoryNamePath(categoryName, subCategoryName)
        .setData({TextConfig.otherPictureTwo:otherPictureTwo}, merge: true);
  }
}