import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

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

  pushToFirebase() async{
    print("categoryData in pushToFirebase : $categoryData");
    print("subCategoryData in pushToFirebase : $subCategoryData");
    await Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo).setData({}, merge: true);
    /// add videoURL
    /// home location
    /// categories
    await Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo)
        .collection(categoryData).document(subCategoryData)
        .setData({'bazaarWalaName': userName,'videoURL': videoURL, 'latitude': latitude,
      'longitude': longitude,'radius' : radius,'homeService' : homeService }, merge: true);
  }

  pushAllPictures(String categoryName, String subCategoryName) async{
    await Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo)
        .collection(categoryName).document(subCategoryName)
        .setData({"thumbnailPicture":thumbnailPicture, "otherPictureOne":otherPictureOne, "otherPictureTwo" :otherPictureTwo }, merge: true);
  }

  pushThumbnailPicture(String categoryName, String subCategoryName) async{
    await Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo)
        .collection(categoryName).document(subCategoryName)
        .setData({"thumbnailPicture":thumbnailPicture,}, merge: true);
  }

  pushOtherPictureOne(String categoryName, String subCategoryName) async{
    await Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo)
        .collection(categoryName).document(subCategoryName)
        .setData({"otherPictureOne":otherPictureOne}, merge: true);
  }

  pushOtherPictureTwo(String categoryName, String subCategoryName) async{
    await Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo)
        .collection(categoryName).document(subCategoryName)
        .setData({"otherPictureTwo":otherPictureTwo}, merge: true);
  }
}