import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/widgets/createContainer.dart';
import 'package:gupshop/widgets/displayPicture.dart';
import 'package:gupshop/widgets/verticalPadding.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';




class ImagesPickersDisplayPictureURLorFile {

  String imageURL;
  String userPhoneNo;


  /// This funcion will helps you to pick and Image from Gallery
  pickImageFromGallery() async{
    return await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
  }


  /// This funcion will helps you to pick and Image from Camera
  pickImageFromCamer() async{
    return await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 50);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }


  displayPictureFromFile(File image){
    ImageProvider ip = new FileImage(image);
    return DisplayPicture(height: 370,width: 370, image: ip);
  }

  displayPictureFromURL(String image){
    ImageProvider ip = NetworkImage(image);
    return DisplayPicture(height: 370,width: 370, image: ip);
  }


  getImageURL(File galleryImage, String userPhoneNo, int number) async{
    String fileName = basename(galleryImage.path);
    //String fileName = basename(_galleryImage.path);
    StorageReference firebaseStorageReference= FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageReference.putFile(galleryImage);
    StorageTaskSnapshot imageURLFuture = await uploadTask.onComplete;
    imageURL = await imageURLFuture.ref.getDownloadURL();
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

//    setState(() {
//      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture uploaded'),));
//    });
  }


}