import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/widgets/createContainer.dart';
import 'package:gupshop/widgets/verticalPadding.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PictureUploader extends StatefulWidget {
  final double size = 150;

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

//To do - remove this, take userphone number from class before this
  Future<void> getUserPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userPhoneNo = prefs.getString('userPhoneNo');
    setState(() {
      this.userPhoneNo = userPhoneNo;
    });
    print("userPhoneNo: $userPhoneNo");
    print("prefs: $prefs");
  }

    displayPictureFromFile(File image){
      return Container(
        height: 300,
        width: 300,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
        ),
        child:Image.file(image),
      );
  }

//Image.file(image),
  displayPictureFromURL(String image){
    return Container(
      height: 300,
      width: 300,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
      ),
      child:Image(image: NetworkImage(image)),
    );
  }



//  displayPictureFromFile(File image){
//    return Container(
//      width: 400,
//      height: 400,
//      decoration: new BoxDecoration(
//        shape: BoxShape.circle,
//        border: new Border.all(
//          color: Colors.blue,
//          width: 3.0,
//        ),
//        gradient: LinearGradient(
//          begin: Alignment.topCenter,
//          end: Alignment.bottomCenter,
//          colors: [
//            Colors.transparent,
//            Colors.black12,
//          ],
//        ),
//      ),
//      child:
//      CircleAvatar(
//        child: new ClipOval(
//          child: Image.file(
//          image,
//          width: 400,
//          height: 400,
//          fit: BoxFit.cover,
//          ),
////          borderRadius: BorderRadius.circular(100),
//        ),
//      ),
//      //,fit: BoxFit.scaleDown,
//    );
//  }
//
//  displayPictureFromURL(String image){
//    return Container(
//      width: 400,
//      height: 400,
//      decoration: new BoxDecoration(
//        shape: BoxShape.circle,
//        border: new Border.all(
//          color: Colors.blue,
//          width: 3.0,
//        ),
//        gradient: LinearGradient(
//          begin: Alignment.topCenter,
//          end: Alignment.bottomCenter,
//          colors: [
//            Colors.transparent,
//            Colors.black12,
//          ],
//        ),
//      ),
//      child:
//      CircleAvatar(
//        child: ClipOval(child: Image(
//          image: NetworkImage(image),
//          width: 400,
//          height: 400,
//          fit: BoxFit.cover,
//        ),
//        ),
//      ),
//      //,fit: BoxFit.scaleDown,
//      //child: CreateContainer(child: Image(image: NetworkImage(image), fit: BoxFit.fitWidth,)),
//    );
//  }


//  displayPictureFromFile(File image){
//      return Padding(
//        padding: const EdgeInsets.only(right: 10, left: 10),
//        child: Image.file(image),
//        //,fit: BoxFit.scaleDown,
//      );
//  }
//
//  displayPictureFromURL(String image){
//      return Padding(
//        padding: const EdgeInsets.only(right: 10, left: 10),
//        child: Image(image: NetworkImage(image)),
//        //,fit: BoxFit.scaleDown,
//        //child: CreateContainer(child: Image(image: NetworkImage(image), fit: BoxFit.fitWidth,)),
//      );
//  }



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