import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/image/displayCircularPicture.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/video/createVideoURL.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';


/// toDO- use video package method and delete this class
class ImagesPickersDisplayPictureURLorFile {

  String imageURL;
  String userPhoneNo;

  displayPictureFromFile(File image, double height, double width){
    ImageProvider ip = new FileImage(image);
    return DisplayCircularPicture(height: height,width: width, image: ip);
  }

  displayPictureFromURL(String image, double height, double width){
    ImageProvider ip;

    /// for 1st time user, we are giving an image from our assets as his dp
    /// So we are just checking if he is the 1st time user, then display the image from
    /// assets, else display from Netwrok i.e firebase
    if(image == ImageConfig.userDpPlaceholder){
//    if(image == 'images/user.png'){
      ip = AssetImage(image);
    }else ip = NetworkImage(image);

    return DisplayCircularPicture(height: height,width: width, image: ip);
  }

  getVideoURL(File galleryImage, String userPhoneNo, int number, BuildContext context) async{
    imageURL = await CreateVideoURL().create(context, galleryImage, userPhoneNo, number);
    return imageURL;
  }


  Future uploadImageToFirestore(BuildContext context, String userPhoneNo, File _galleryImage) async{//functionality for cameraImage is not added, thats a to do
    String fileName = basename(userPhoneNo+'ProfilePicture');
    //String fileName = basename(_galleryImage.path);
    StorageReference firebaseStorageReference= FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageReference.putFile(_galleryImage);
    StorageTaskSnapshot imageURLFuture = await uploadTask.onComplete;
    imageURL = await imageURLFuture.ref.getDownloadURL();
    print("imageurl: $imageURL");
    Firestore.instance.collection("profilePictures").document(userPhoneNo).setData({'url':imageURL});

  }


}