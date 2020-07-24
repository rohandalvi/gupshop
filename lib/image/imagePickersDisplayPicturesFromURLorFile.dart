import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/displayPicture.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';


/// toDO- use video package method and delete this class
class ImagesPickersDisplayPictureURLorFile {

  String imageURL;
  String userPhoneNo;


  /// This funcion will helps you to pick and Image from Gallery
//  pickImageFromGallery() async{
//    return await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
//  }


  /// This funcion will helps you to pick and Image from Camera
//  pickImageFromCamer() async{
//    return await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 50);
//  }

//  cropImage(File tempImage) async{
//    File croppedImage = await ImageCropper.cropImage(
//      sourcePath: tempImage.path,
//      aspectRatio: CropAspectRatio(
//        ratioX: 1.0,
//        ratioY: 1.0,
//      ),
//      maxWidth: 512,
//      maxHeight: 512,
//    );
//
//    return croppedImage;
//  }


  displayPictureFromFile(File image, double height, double width){
    ImageProvider ip = new FileImage(image);
    return DisplayPicture(height: height,width: width, image: ip);
  }

  displayPictureFromURL(String image, double height, double width){
    ImageProvider ip;

    /// for 1st time user, we are giving an image from our assets as his dp
    /// So we are just checking if he is the 1st time user, then display the image from
    /// assets, else display from Netwrok i.e firebase
    if(image == 'images/user.png'){
      ip = AssetImage(image);
    }else ip = NetworkImage(image);

    return DisplayPicture(height: height,width: width, image: ip);
  }


//  getImageURL(File galleryImage, String userPhoneNo, int number) async{
//    String fileName = basename(galleryImage.path);
//    //String fileName = basename(_galleryImage.path);
//    StorageReference firebaseStorageReference= FirebaseStorage.instance.ref().child(fileName);
//    StorageUploadTask uploadTask = firebaseStorageReference.putFile(galleryImage);
//    StorageTaskSnapshot imageURLFuture = await uploadTask.onComplete;
//    imageURL = await imageURLFuture.ref.getDownloadURL();
//    return imageURL;
//  }

  getVideoURL(File galleryImage, String userPhoneNo, int number) async{
    String fileName = basename(galleryImage.path);
    //String fileName = basename(_galleryImage.path);
    StorageReference firebaseStorageReference= FirebaseStorage.instance.ref().child("video").child(fileName);
    StorageUploadTask uploadTask = firebaseStorageReference.putFile(galleryImage, StorageMetadata(contentType: 'video/mp4'));
    StorageTaskSnapshot imageURLFuture = await uploadTask.onComplete;
    imageURL = await imageURLFuture.ref.getDownloadURL();
    print("imageURL in getVideoURL: $imageURL");
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