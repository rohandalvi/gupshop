import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class PushToBazaarWalasBasicProfile{
  String userPhoneNo;
  String userName;
  String thumbnailPicture;
  String otherPictureOne;
  String otherPictureTwo;

  PushToBazaarWalasBasicProfile({@required this.userPhoneNo, this.userName,
    this.thumbnailPicture, this.otherPictureTwo, this.otherPictureOne
  });

  pushToFirebase(String videoURL, double latitude, double longitude, List<String> categories, String categoryName) async{
    await Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo).setData({}, merge: true);
    /// add videoURL
    /// home location
    /// categories
    await Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo).setData({'bazaarWalaName': userName,'videoURL': videoURL, 'latitude': latitude, 'longitude': longitude, 'categories':categories, });
  }

  pushAllPictures() async{
    await Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo)
        .setData({"thumbnailPicture":thumbnailPicture, "otherPictureOne":otherPictureOne, "otherPictureTwo" :otherPictureTwo }, merge: true);
  }

  pushThumbnailPicture() async{
    print("userPhoneNo in pushThumbnailPicture : $userPhoneNo");
    print("thumbnailPicture : $thumbnailPicture");
    await Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo)
        .setData({"thumbnailPicture":thumbnailPicture,}, merge: true);
  }

  pushOtherPictureOne() async{
    await Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo)
        .setData({"otherPictureOne":otherPictureOne}, merge: true);
  }

  pushOtherPictureTwo() async{
    await Firestore.instance.collection("bazaarWalasBasicProfile").document(userPhoneNo)
        .setData({"otherPictureTwo":otherPictureTwo}, merge: true);
  }
}