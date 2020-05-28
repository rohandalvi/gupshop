import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PictureUploader extends StatefulWidget {
  @override
  PictureUploaderState createState() => PictureUploaderState();
}

class PictureUploaderState extends State<PictureUploader> {

  String imageURL;
  String userPhoneNo;

  @override
  void initState() {
    getUserPhone();
    super.initState();
  }


  File _galleryImage ;
  // This funcion will helps you to pick and Image from Gallery
  pickImageFromGallery() async{
    return await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);

//    setState((){
//      _galleryImage= image;
//    });
  }


  File _cameraImage;
  // This funcion will helps you to pick and Image from Camera
  pickImageFromCamer() async{
    File image = await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 50);

    setState(() {
      _cameraImage= image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  /*
  When apply button is pressed on change profile page then the image gets stored in firestore storage
  How:
    Use path for making a simple path of the image file
    Create an instance of StorageRefrence and pass the path to it//get the file name
    Use StorageUploadTask putFile  method to on the StorageRefrence instance//put it to firebase
    Use StorageTaskSnapshot on the the StorageUploadTask above//to know then the task is completed
    Then setState()//to display the image
   */
  /*
    But this context cannot be used directly, as the context there is no context given to the scaffold
    The context in the Widget build(Buildcontext context) is the context of that build widget, but not
    of the Scaffold, we get error :
    - Scaffold.of() called with a context that does not contain a Scaffold.
    To avoid, this we wrap the widget Center with Builder, which takes context as its parameter
   */


  Future<void> getUserPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userPhoneNo = prefs.getString('userPhoneNo');
    setState(() {
      this.userPhoneNo = userPhoneNo;
    });
    print("userPhoneNo: $userPhoneNo");
    print("prefs: $prefs");
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


  Future uploadImageToFirestore(BuildContext context) async{//functionality for cameraImage is not added, thats a to do
    String fileName = basename(userPhoneNo+'ProfilePicture');
    //String fileName = basename(_galleryImage.path);
    StorageReference firebaseStorageReference= FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageReference.putFile(_galleryImage);
    StorageTaskSnapshot imageURLFuture = await uploadTask.onComplete;
    imageURL = await imageURLFuture.ref.getDownloadURL();
    print("imageurl: $imageURL");
    Firestore.instance.collection("profilePictures").document(userPhoneNo).setData({'url':imageURL});

    setState(() {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture uploaded'),));
    });
  }


}